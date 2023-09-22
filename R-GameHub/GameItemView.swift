//
//  GameItemView.swift
//  R-GameHub
//
//  Created by Toan Tran Chi on 20/09/2023.
//

import SwiftUI
import Firebase

struct GameItemView: View {
    @State var game: Game
    @StateObject var gameViewModel = GameViewModel()
    
    func checkUIDAndDelete () {
        let uid = Auth.auth().currentUser!.uid
        if game.userID == uid {
            gameViewModel.removeGameData(documentID: game.documentID ?? "")
        }
    }
//    var rating: Float = 0
    var body: some View {
        let rating = Double(game.rating.reduce(0, +)) / Double(game.rating.count)
//        ForEach(game.rating, id:\.self) { item in
//            rating
//        }
        VStack{
            HStack{
                Text(game.name)
                Button {
                    checkUIDAndDelete()
                } label: {
                    Text("Delete")
                }
            }
            Text(game.description)
            HStack{
                Text(game.developer)
                Text(String(game.price))
            }
                ScrollView(.horizontal) {
                    LazyHStack{
                        ForEach(game.genre, id:\.self) { item in
                            Text(item)
                        }
                    }
                    LazyHStack{
                        ForEach(game.platform, id:\.self) { item in
                            Text(item)
                        }
                    }
                }
                .frame(width: 200, height: 50)
                AsyncImage(url: URL(string: game.imageURL))
                    .scaledToFill()
                    .frame(width: 200, height: 200)
                    .clipped()
            Text("Rating: \(rating)")
        }
    }
}

struct GameItemView_Previews: PreviewProvider {
    static var previews: some View {
        GameItemView(game: Game(name: "Elden Ring", description: "", price: 0 ,platform: ["PS4", "Xbox"], genre: ["Action", "RPG", "OpenWorld", "Soul-like"], developer: "FromSoftware", rating: [5,4,5,5,4,5], imageURL: "https://firebasestorage.googleapis.com/v0/b/ios-app-4da46.appspot.com/o/eldenring.jpg?alt=media&token=25132cbc-e9e2-432f-b072-5c04cf92183d", userID: "123456"))
    }
}
