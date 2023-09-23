//
//  CartView.swift
//  R-GameHub
//
//  Created by Toan Tran Chi on 22/09/2023.
//

import SwiftUI
import Firebase

struct CartView: View {
    @StateObject var gameViewModel = GameViewModel()
    @StateObject var cartViewModel = CartViewModel()
    @State var uid = ""
    @State var gameArray = [""]
    @State var selectedGame: Game = Game(name: "", description: "", price: 0, platform: [""], genre: [""], developer: "", rating: [0], imageURL: "", userID: "")
    
    func removeFromCart(documentID: String?, gameID: String) {
        let index = gameArray.firstIndex(of: gameID) ?? 0
        gameArray.remove(at: index)
        cartViewModel.updateGamelist(documentID: documentID ?? "", gamelist: gameArray)
    }
    
    var body: some View {
        let games = gameViewModel.games
        let carts = cartViewModel.carts
        VStack {
            Text("Cart")
            ScrollView {
                ForEach(games, id: \.id) {game in
                    ForEach(carts, id: \.id) {cart in
                        ForEach(cart.gameID, id: \.self) {item in
                            if item == game.documentID {
                                CartItemView(game: game, UID: uid)
                                Button {
                                    gameArray = cart.gameID
                                    removeFromCart(documentID: cart.documentID,gameID: item)
                                } label: {
                                    Text("REMOVE")
                                }
                            }
                        }
                    }
                }
            }
//            ForEach(gameArray, id: \.self) { item in
//                Text(item)
//            }
        }
    }
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView()
    }
}
