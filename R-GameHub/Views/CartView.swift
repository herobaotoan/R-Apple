//
//  CartView.swift
//  R-GameHub
//
//  Created by Toan Tran Chi on 22/09/2023.
//

import SwiftUI
import Firebase

struct CartView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    var isCompact: Bool {horizontalSizeClass == .compact}
    
    @AppStorage("isDarkMode") private var isDark = false
    
    @StateObject var gameViewModel = GameViewModel()
    @StateObject var cartViewModel = CartViewModel()
    @State var uid = "zhW4xMPXYya8nGiUSDNJ5AR1yiu2"
    @State var gameArray = [""]
    @State var selectedGame: Game = Game(name: "", description: "", price: 0, platform: [""], genre: [""], developer: "", rating: [0], imageURL: "", userID: "")
    @State private var totalPrice: Double = 0
    
    func removeFromCart(documentID: String?, gameID: String) {
        let index = gameArray.firstIndex(of: gameID) ?? 0
        gameArray.remove(at: index)
        cartViewModel.updateGamelist(documentID: documentID ?? "", gamelist: gameArray)
    }
    
    var body: some View {
        let games = gameViewModel.games
        let carts = cartViewModel.carts
        ZStack {
            CustomColor.secondaryColor
                .edgesIgnoringSafeArea(.all)
            ZStack {
                // Game price and buy
                ZStack {
                    CustomColor.secondaryColor
                    VStack {
                        HStack {
                            // Game price
                            Text("$\(totalPrice, specifier: "%.2f")")
                                .font(.system(size: 26))
                                .multilineTextAlignment(.leading)
                                .italic()
                                .foregroundColor(CustomColor.lightDarkColor)
                                .padding(.leading, 30)
                            
                            Spacer()
                            
                            // Purchase button
                            Button {

                            } label: {
                                Text("Purchase")
                                    .font(.system(size: 20))
                                    .fontWeight(.medium)
                            }
                            .frame(width: 110, height: 40, alignment: .center)
                            .background(CustomColor.primaryColor)
                            .foregroundColor(CustomColor.darkLightColor)
                            .cornerRadius(10)
                            .padding(.trailing, 30)
                        }
                    }
                    .padding(.bottom, 15)
                }
                .frame(height: 90)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .ignoresSafeArea()
            .zIndex(2)
            VStack {
                Text("Cart")
                    .font(.system(size: 28))
                    .fontWeight(.bold)
                    .foregroundColor(CustomColor.primaryColor)
                List {
                    ForEach(games, id: \.id) {game in
                        ForEach(carts, id: \.id) {cart in
                            ForEach(cart.gameID, id: \.self) {item in
                                if item == game.documentID {
                                    CartItemView(game: game, UID: uid)
                                        .swipeActions {
                                            Button {
                                                gameArray = cart.gameID
                                                removeFromCart(documentID: cart.documentID,gameID: item)
                                            } label: {
                                                Text("REMOVE")
                                                    .foregroundColor(CustomColor.lightDarkColor)
                                            }
                                            .tint(CustomColor.heartColor)
                                        }
                                }
                            }
                        }
                    }
                }
                .padding(.bottom, 50)
                .background(CustomColor.primaryColor)
                .scrollContentBackground(.hidden)
//            ForEach(gameArray, id: \.self) { item in
//                Text(item)
//            }
            }
            .overlay (
                // MARK: - DISMISS CART VIEW BUTTON
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "house.circle.fill")
                        .font(isCompact ? .title : .largeTitle)
                }
                    .foregroundColor(CustomColor.primaryColor)
                    .padding(.leading, isCompact ? 20 : 30)
                    .padding(.top, 2)
                , alignment: .topLeading
            )
        }
        .onAppear() {
            cartViewModel.getUserCartData(uid: uid)
        }
        .environment(\.colorScheme, isDark ? .dark : .light)
    }
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView()
    }
}
