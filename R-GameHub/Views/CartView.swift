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

struct CartView: View {
    // MARK: - DECLARE VARIABLES
    @Environment(\.dismiss) var dismiss
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    var isCompact: Bool {horizontalSizeClass == .compact}
    
    @AppStorage("isDarkMode") private var isDark = false
    
    @StateObject var gameViewModel = GameViewModel()
    @StateObject var cartViewModel = CartViewModel()
    @StateObject var userViewModel = UserViewModel()
    @Binding var UID: String
    @State var gameArray = [""]
    @State var totalMoney: Double = 0.0
    @State var currentMoney: Double = 0.0
    
    // MARK: - REMOVE GAME FROM CART
    func removeFromCart(documentID: String?, gameID: String) {
        let index = gameArray.firstIndex(of: gameID) ?? 0
        gameArray.remove(at: index)
        cartViewModel.updateCart(documentID: documentID ?? "", gamelist: gameArray)
    }
    
    // MARK: - CALCULATE TOTAL PRICE
    func getTotalPrice() -> Double {
        var totalPrice: Double = 0
        for cart in cartViewModel.carts {
            for id in cart.gameID {
                for game in gameViewModel.games {
                    if id == game.documentID ?? "" {
                        totalPrice += game.price
                    }
                }
            }
        }
        return totalPrice
    }
    
    // MARK: - GET USER MONEY
    func getUserMoney() -> Double {
        var money: Double = 0
        for user in userViewModel.user {
            if UID == user.id {
                money += user.money
            }
        }
        return money
    }
    
    // MARK: - FUNCTION PAYMENT
    func purchase() {
        for cart in cartViewModel.carts {
            if cart.uid == UID {
                cartViewModel.updateCart(documentID: cart.documentID ?? "", gamelist: [""])
            }
        }
        for user in userViewModel.user {
            if user.id == UID {
                userViewModel.updateMoney(UID: UID, money: getUserMoney() - getTotalPrice())
            }
        }
    }
    
    // MARK: - CART VIEW
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
                            Text("$\(getTotalPrice(), specifier: "%.2f")")
                                .font(.system(size: isCompact ? 26 : 44))
                                .multilineTextAlignment(.leading)
                                .italic()
                                .foregroundColor(CustomColor.lightDarkColor)
                                .padding(.leading, isCompact ? 30 : 50)
                            
                            Spacer()
                            
                            // Purchase button
                            Button {
                                if currentMoney >= totalMoney {
                                    purchase()
                                }
                            } label: {
                                Text("Purchase")
                                    .font(.system(size: isCompact ? 20 : 34))
                                    .fontWeight(.medium)
                            }
                            .frame(width: isCompact ? 110 : 160, height: isCompact ? 40 : 60, alignment: .center)
                            .background(CustomColor.primaryColor)
                            .foregroundColor(CustomColor.darkLightColor)
                            .cornerRadius(10)
                            .padding(.trailing, isCompact ? 30 : 50)
                        }
                    }
                    .padding(.bottom, isCompact ? 15 : 20)
                }
                .frame(height: isCompact ? 90 : 120)
                .clipShape(RoundedRectangle(cornerRadius: isCompact ? 20 : 30))
                
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .ignoresSafeArea()
            .zIndex(2)
            VStack {
                Text("Cart")
                    .font(.system(size: isCompact ? 28 : 48))
                    .fontWeight(.bold)
                    .foregroundColor(CustomColor.primaryColor)
                
                Text("Money: $\(getUserMoney(), specifier: "%.2f")")
                    .font(.system(size: isCompact ? 22 : 40))
                    .fontWeight(.medium)
                    .padding(.top, isCompact ? 1 : 2)
                    .foregroundColor(CustomColor.lightDarkColor)
                List {
                    ForEach(games, id: \.id) {game in
                        ForEach(carts, id: \.id) {cart in
                            ForEach(cart.gameID, id: \.self) {item in
                                if item == game.documentID {
                                    CartItemView(game: game, UID: UID)
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
                .padding(.bottom, isCompact ? 40 : 90)
                .background(CustomColor.primaryColor)
                .scrollContentBackground(.hidden)
            }
            .overlay (
                // MARK: - DISMISS CART VIEW BUTTON
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "house.fill")
                        .font(isCompact ? .title : .largeTitle)
                }
                    .foregroundColor(CustomColor.primaryColor)
                    .padding(.leading, isCompact ? 20 : 30)
                    .padding(.top, isCompact ? 2 : 12)
                , alignment: .topLeading
            )
        }
        .onAppear() {
            cartViewModel.getUserCartData(uid: UID)
        }
        .environment(\.colorScheme, isDark ? .dark : .light)
    }
}

// MARK: - PREVIEWS
struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView(UID: .constant("zhW4xMPXYya8nGiUSDNJ5AR1yiu2"))
    }
}
