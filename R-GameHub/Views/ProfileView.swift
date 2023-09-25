/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2023B
  Assessment: Assignment 3
  Author: R-Apple (Bui Nguyen Ngoc Tuan | Vo Tran Khanh Linh | Tran Chi Toan | Nguyen Thi Ha Giang | Nguyen Tuan Thang)
  ID: s3877673 | s3878600 | s3891637 | s3914108 | s3877039
  Created  date: 15/09/2023
  Last modified: 25/09/2023
  Acknowledgement: Previous assignments of members | Firebase lectures on Canvas | YouTube | Stackoverflow
*/

import SwiftUI
import Firebase
import FirebaseStorage

struct ProfileView: View {
    let storage: Storage = Storage.storage()
    @Binding var UID: String
    @StateObject var userViewModel = UserViewModel()
    @State var name = ""
    @State var email = ""
    @State var imageURL = ""
    @State var image: UIImage?
    @State var shouldShowImagePicker = false
    func upload() {
        persistImageToStorage()
    }
    private func persistImageToStorage() {
        let uid = Auth.auth().currentUser!.uid
        let ref = storage.reference(withPath: uid).child("images/\(Int.random(in: 1..<999999))")
        guard let imageData = self.image?.jpegData(compressionQuality: 0.5) else { return }
        ref.putData(imageData, metadata: nil) { metadata, err in
            if let err = err {
//                    self.loginStatusMessage = "Failed to push image to Storage: \(err)"
                return
            }
            ref.downloadURL { url, err in
                if let err = err {
//                        self.loginStatusMessage = "Failed to retrieve downloadURL: \(err)"
                    return
                }
                imageURL = url?.absoluteString ?? ""
                userViewModel.updateUserImage(UID: UID, imageURL: imageURL)
//                self.loginStatusMessage = "Successfully Added Game"
            }
        }
    }
    
    var body: some View {
        
        VStack {
            Text("WELCOME!!")
            ForEach(userViewModel.user, id: \.uid) {user in
                if (user.id == UID) {
                    Text(user.name)
                    Text(user.email)
                    Text(user.phone)
                    Button {
                        shouldShowImagePicker.toggle()
                    } label: {
                        
                        if let image = self.image {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 128, height: 128)
                                .cornerRadius(64)
                        } else {
                            AsyncImage(url: URL(string: user.imageURL))
                                .scaledToFill()
                                .frame(width: 128, height: 128)
                                .cornerRadius(64)
                        }
                    }
                    .overlay(RoundedRectangle(cornerRadius: 64)
                        .stroke(Color.black, lineWidth: 3)
                    )
                }
            }
            
            Button {
                upload()
            }label: {
                Text("CHANGE AVA")
            }
            
            HStack {
                TextField("Name: ", text: $name)
                Button {
                    userViewModel.updateUserName(UID: UID, name: name)
                } label: {
                    Text("Change")
                }
            }
            HStack {
                TextField("Email: ", text: $email)
                Button {
//                    userViewModel.updateUserEmail(UID: UID, email: email)
                } label: {
                    Text("Change")
                }
            }
//            TextField("Image: ", text: $name)
        }
        .frame(width: 300)
        .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
            ImagePicker(image: $image)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(UID: .constant("zhW4xMPXYya8nGiUSDNJ5AR1yiu2"))
    }
}
