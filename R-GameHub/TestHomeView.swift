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
    @StateObject var cartViewModel = CartViewModel()
    @State var name = ""
    @State var dev = ""
    @State var des = ""
    @State var priceString = ""
    @State var price: Double = 0.0
    @State var genreText = ""
    @State var platformText = ""
    @State var imageURL = ""
    @State var genres : [String] = []
    @State var platforms : [String] = []
    
    @State var cart: [String] = []
    
    @State var image: UIImage?
    @State var shouldShowImagePicker = false
    @State var loginStatusMessage = ""
    //Binding this UID
    @State var UID = "zhW4xMPXYya8nGiUSDNJ5AR1yiu2"
    
//    @State var cart: [String] = [""]
    
    @State private var showGameDetailView = false
    @State var selectedGame: Game = Game(name: "", description: "", price: 0, platform: [""], genre: [""], developer: "", rating: [0], imageURL: "", userID: "")
    
    func upload(){
        persistImageToStorage()
    }
    func getCart(item: Cart){
        cart = item.gameID
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
                price = Double(priceString)!
                gameViewModel.addNewGameData(newGame: Game(name: name, description: des, price: price, platform: platforms, genre: genres, developer: dev, rating: [5], imageURL: imageURL, userID: uid))
                    self.loginStatusMessage = "Successfully Added Game"
            }
        }
    }
    
//    func getCart(gamelist: [String]) {
//        cart = gamelist
//    }
    
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
            TextField("Description: ", text: $des)
            TextField("Price: ", text: $priceString).keyboardType(.decimalPad)
            HStack{
                TextField("Genre: ", text: $genreText)
                Button {
                    genres.append(genreText)
                    genreText = ""
                } label: {
                    Text("Add")
                }
            }
            HStack{
                TextField("Platfrom: ", text: $platformText)
                Button {
                    platforms.append(platformText)
                    platformText = ""
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
                    GameItemView(game: game, gamelist: $cart, UID: UID)
                }
                ForEach(cartViewModel.carts, id: \.id) { carts in
                    Text("")
                        .onAppear() {
                            getCart(item: carts)
                        }
                }
            }
        }
        .onAppear() {
            cartViewModel.getUserCartData(uid: UID)
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
