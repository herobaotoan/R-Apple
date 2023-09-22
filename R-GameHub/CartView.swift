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
    @State var cart: [Cart] = [Cart(uid: "", gameID: [""])]
    @State var cartItem: [String] = []
    @State var selectedGame: Game = Game(name: "", description: "", price: 0, platform: [""], genre: [""], developer: "", rating: [0], imageURL: "", userID: "")
    func GetCartItem(a : [Game]) {
        uid = Auth.auth().currentUser!.uid
        cart = cartViewModel.carts
//        ForEach(cartViewModel.carts, id: \.id) { cart in
//            if cart.uid == uid {
//
//            }
//        }
//        cartItem.append(a[0].name)
//        for cart in 0 ..< a.count + 1{
//            if cartViewModel.carts[cart].uid == uid {
//                cartItem.append(contentsOf: cartViewModel.carts[cart].gameID)
//            }
//            print(cart)
//            cartItem.append(a[cart].name)
//        }
    }
    func test() {
        cartItem.append("")
    }
    var body: some View {
        let cart = cartViewModel.carts
        let carts = gameViewModel.games
        VStack{
            Text("Cart: \(uid)")
                .onAppear() {
                    GetCartItem(a: carts)
                }
            ForEach(cartItem, id: \.self) { item in
                Text(item)
            }

            ScrollView{
                ForEach(gameViewModel.games, id: \.id) { game in
                    ForEach(cartViewModel.carts, id: \.id) { cart in
                        ForEach(cart.gameID, id: \.self) { item in
                            if item == game.documentID {
                                GameItemView(game: game)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView()
    }
}
