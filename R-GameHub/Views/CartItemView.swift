//
//  CartItemView.swift
//  R-GameHub
//
//  Created by Стивен on 23/09/2023.
//

import SwiftUI
import Firebase

struct CartItemView: View {
    @State var game: Game
    @State var UID: String
    var body: some View {
        ZStack {
            HStack {
                AsyncImage(url: URL(string: game.imageURL))
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipped()
            }
        }
    }
}

struct CartItemView_Previews: PreviewProvider {
    static var previews: some View {
        CartItemView(game: Game(name: "Elden Ring", description: "", price: 0 ,platform: ["PS4", "Xbox"], genre: ["Action", "RPG", "OpenWorld", "Soul-like"], developer: "FromSoftware", rating: [5,4,5,5,4,5], imageURL: "https://firebasestorage.googleapis.com/v0/b/ios-app-4da46.appspot.com/o/eldenring.jpg?alt=media&token=25132cbc-e9e2-432f-b072-5c04cf92183d", userID: "123456"), UID: "zhW4xMPXYya8nGiUSDNJ5AR1yiu2")
    }
}
