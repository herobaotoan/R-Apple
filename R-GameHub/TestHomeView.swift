//
//  TestHomeView.swift
//  R-GameHub
//
//  Created by Toan Tran Chi on 19/09/2023.
//

import SwiftUI
import Firebase
import FirebaseStorage

struct TestHomeView: View {
    let storage: Storage = Storage.storage()
    @StateObject var gameViewModel = GameViewModel()
    @State var name = ""
    @State var dev = ""
    @State var genreText = ""
    @State var platformText = ""
    @State var imageURL = ""
    @State var genres : [String] = []
    @State var platforms : [String] = []
    
    @State var image: UIImage?
    @State var shouldShowImagePicker = false
    @State var loginStatusMessage = ""
    
    func upload(){
        persistImageToStorage()
    }
    
    private func persistImageToStorage() {
        let uid = Auth.auth().currentUser!.uid
        let ref = storage.reference(withPath: uid).child("images/\(Int.random(in: 1..<999999))")
        print("Helo")
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
                gameViewModel.addNewGameData(newGame: Game(name: name, platform: platforms, genre: genres, developer: dev, rating: [5], imageURL: imageURL, userID: uid))
                    self.loginStatusMessage = "Successfully Added Game"
            }
        }
    }
    
    var body: some View {
        VStack {
            Text(loginStatusMessage)
            Button {
                shouldShowImagePicker.toggle()
            } label: {
                VStack {
                    if let image = self.image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 128, height: 128)
                            .cornerRadius(64)
                    } else {
                        Image(systemName: "person.fill")
                            .font(.system(size: 64))
                            .padding()
                            .foregroundColor(Color(.label))
                    }
                }
                .overlay(RoundedRectangle(cornerRadius: 64)
                            .stroke(Color.black, lineWidth: 3)
                )
            }
            TextField("Name: ", text: $name)
            TextField("Dev: ", text: $dev)
            HStack{
                TextField("Genre: ", text: $genreText)
                Button {
                    genres.append(genreText)
                } label: {
                    Text("Add")
                }
            }
            HStack{
                TextField("Platfrom: ", text: $platformText)
                Button {
                    platforms.append(genreText)
                } label: {
                    Text("Add")
                }
            }
            Button {
                upload()
            } label: {
                Text("Add Game")
            }
            ScrollView{
                ForEach(gameViewModel.games, id: \.id) { game in
                    GameItemView(game: game)
                }
            }
        }
        .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
            ImagePicker(image: $image)
        }
    }
}

struct TestHomeView_Previews: PreviewProvider {
    static var previews: some View {
        TestHomeView()
    }
}
