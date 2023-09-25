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

struct ProfileViewUI: View {
    // MARK: - DECLARE VARIABLES
    @Environment(\.dismiss) var dismiss
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    var isCompact: Bool {horizontalSizeClass == .compact}
    
    @AppStorage("isDarkMode") private var isDark = false
    @Binding var UID: String
    @StateObject var userViewModel = UserViewModel()
    @State var name = ""
    @State var imageURL = ""
    @State var image: UIImage?
    @State var isHomeView: Bool = false
    @State var isChangingName: Bool = false
    @State var loggingOut: Bool = false
    @State var shouldShowImagePicker = false
    @State var loginStatusMessage = ""
    
    let storage: Storage = Storage.storage()
    
    func upload() {
        persistImageToStorage()
    }
    
    private func persistImageToStorage() {
       let uid = Auth.auth().currentUser!.uid
       let ref = storage.reference(withPath: uid).child("images/\(Int.random(in: 1..<999999))")
       guard let imageData = self.image?.jpegData(compressionQuality: 0.5) else { return }
       ref.putData(imageData, metadata: nil) { metadata, err in
           if let err = err {
                self.loginStatusMessage = "Failed to push image to Storage: \(err)"
               return
           }
           ref.downloadURL { url, err in
               if let err = err {
                    self.loginStatusMessage = "Failed to retrieve downloadURL: \(err)"
                   return
               }
               imageURL = url?.absoluteString ?? ""
               userViewModel.updateUserImage(UID: UID, imageURL: imageURL)
               //                self.loginStatusMessage = "Successfully Added Game"
           }
       }
    }
    
    var body: some View {
        // MARK: - NAVIGATE TO HOME VIEW
        if isHomeView {
            HomeView(UID: $UID)
        } else if loggingOut {  // MARK: - NAVIGATE TO LOGIN VIEW
            LogInView()
        } else {
            // MARK: - PROFILE VIEW
            ZStack {
                CustomColor.primaryColor
                    .edgesIgnoringSafeArea(.all)
                ForEach(userViewModel.user, id: \.uid) {user in
                    if user.id == UID {
                        VStack {
                            HStack {
                                Button {
                                    isHomeView = true
                                } label: {
                                    Image(systemName: "house.fill")
                                        .font(isCompact ? .title : .largeTitle)
                                        .foregroundColor(CustomColor.secondaryColor)
                                }
                                
                                Spacer()
                                
                                // setting for the user
                                Menu {
                                    Button {
                                        isChangingName = true
                                    } label: {
                                        Label("Edit profile", systemImage: "person.fill")
                                    }
                                    
                                    Button(role: .destructive) {
                                        loggingOut = true
                                    } label: {
                                        Label("Log out", systemImage: "minus.circle")
                                    }
                                } label: {
                                    Image(systemName: "gearshape.fill")
                                        .font(isCompact ? .title : .largeTitle)
                                        .foregroundColor(CustomColor.secondaryColor)
                                }
                            }
                            .padding()
                            
                            ScrollView {
                                Button {
                                    shouldShowImagePicker.toggle()
                                } label: {
                                    if let image = self.image {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: isCompact ? 150 : 200,  height: isCompact ? 150 : 200)
                                            .cornerRadius(64)
                                    } else {
                                        AsyncImage(url: URL(string: user.imageURL)) {image in
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                        } placeholder: {
                                            Image("ava")
                                        }
                                        .frame(width: isCompact ? 150 : 200,  height: isCompact ? 150 : 200)
                                        .clipShape(Circle())
                                        .clipped()
                                    }
                                }
                                
                                Button {
                                    upload()
                                } label: {
                                    Text("Change Avatar")
                                        .font(.system(size: isCompact ? 20 : 34))
                                        .fontWeight(.semibold)
                                        .foregroundColor(CustomColor.secondaryColor)
                                }
                                .padding(.bottom, isCompact ? 5 : 10)
                                Text(loginStatusMessage)
                                
                                Text(user.name)
                                    .font(.system(size: isCompact ? 26 : 46))
                                    .fontWeight(.semibold)
                                    .foregroundColor(CustomColor.secondaryColor)
                                Text(user.email)
                                    .font(.system(size: isCompact ? 22 : 36))
                                    .foregroundColor(CustomColor.secondaryColor)
                                Text(user.phone)
                                    .font(.system(size: isCompact ? 22 : 36))
                                    .foregroundColor(CustomColor.secondaryColor)
                                    .padding(.bottom, isCompact ? 5 : 10)
                                VStack {
                                    HStack(alignment: .center) {
                                        Image(systemName: "dollarsign.circle.fill")
                                            .foregroundColor(CustomColor.starColor)
                                            .font(isCompact ? .title2 : .largeTitle)
                                        Text("Total coins")
                                            .font(.system(size: isCompact ? 22 : 36))
                                            .fontWeight(.medium)
                                            .foregroundColor(CustomColor.secondaryColor)
                                    }
                                    Text("$\(user.money, specifier: "%.2f")")
                                        .font(.system(size: isCompact ? 22 : 36))
                                        .fontWeight(.medium)
                                        .foregroundColor(CustomColor.darkLightColor)
                                }
                                .padding(.bottom, isCompact ? 15 : 30)
                                
                                HStack {
                                    Text("Games Bought")
                                        .fontWeight(.medium)
                                        .font(.system(size: isCompact ? 26 : 46))
                                        .foregroundColor(CustomColor.secondaryColor)
                                    Spacer()
                                }
                                
                                Divider()
                                    .background(CustomColor.secondaryColor)
                                
                                VStack {
                                    
                                }
                            }
                            .padding(isCompact ? 20 : 30)
                        }
                    }
                }
                if isChangingName {
                    let color = CustomColor.secondaryColor
                    ZStack {
                        CustomColor.shadowColor
                            .edgesIgnoringSafeArea(.all)
                        VStack {
                            Text("Change name")
                                .font(.system(size: isCompact ? 24 : 40))
                                .fontWeight(.semibold)
                                .foregroundColor(CustomColor.secondaryColor)
                            HStack {
                                Image(systemName: "person.fill")
                                    .font(isCompact ? .title : .largeTitle)
                                    .padding(isCompact ? 10 : 20)
                                    .foregroundColor(CustomColor.secondaryColor)
                                VStack {
                                    TextField("Name", text: self.$name, axis: .vertical)
                                        .font(.system(size: isCompact ? 20 : 34))
                                    Divider()
                                        .background(CustomColor.secondaryColor)
                                }
                            }
                            
                            Button {
                                userViewModel.updateUserName(UID: UID, name: name)
                                isChangingName = false
                            } label: {
                                Text("Change")
                                    .fontWeight(.medium)
                                    .font(.system(size: isCompact ? 20 : 34))
                                    .frame(width: isCompact ? 90 : 140, height: isCompact ? 50 : 80, alignment: .center)
                                    .background(CustomColor.secondaryColor)
                                    .foregroundColor(CustomColor.lightDarkColor)
                                    .cornerRadius(isCompact ? 10 : 20)
                                    .shadow(color: .black, radius: isCompact ? 2 : 4)
                                    .padding(isCompact ? 15 : 25)
                            }
                        }
                        .padding(isCompact ? 20 : 30)
                        .frame(width: isCompact ? 350 : 600, height: isCompact  ? 250 : 550)
                        .background(CustomColor.lightDarkColor)
                        .cornerRadius(isCompact ? 15 : 30)
                        .overlay (
                            // MARK: - DISMISS CHANGE NAME POPUP
                            Button(action: {
                                isChangingName = false
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(isCompact ? .title : .largeTitle)
                            }
                                .foregroundColor(CustomColor.secondaryColor)
                                .padding([.top, .leading], isCompact ? 20 : 30), alignment: .topLeading
                        )
                    }
                    .zIndex(4)
                }
            }
            .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
                ImagePicker(image: $image)
            }
            .environment(\.colorScheme, isDark ? .dark : .light)
        }
    }
}

// MARK: - PREVIEWS
struct ProfileViewUI_Previews: PreviewProvider {
    static var previews: some View {
        ProfileViewUI(UID: .constant("zhW4xMPXYya8nGiUSDNJ5AR1yiu2"))
    }
}
