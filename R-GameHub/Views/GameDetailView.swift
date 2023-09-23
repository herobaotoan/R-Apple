//
//  GameDetailView.swift
//  R-GameHub
//
//  Created by Стивен on 19/09/2023.
//

import SwiftUI
import Firebase

struct GameDetailView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    var isCompact: Bool {horizontalSizeClass == .compact}
    
    @AppStorage("isDarkMode") private var isDark = false
    
    @State var buy: Bool = false
    @Binding var game: Game
    @State var gamelist: [String] = [""]
    @State var UID: String
    @State var cart: [String] = [""]
    @StateObject var gameViewModel = GameViewModel()
    @StateObject var cartViewModel = CartViewModel()
    @State private var isFavorite: Bool = false
    
    func getCart(gamelist: [String]) {
        cart = gamelist
    }
    
    func checkUIDAndDelete () {
        let uid = Auth.auth().currentUser!.uid
        if game.userID == uid {
            gameViewModel.removeGameData(documentID: game.documentID ?? "")
        }
    }
    func addToCart (id: String?) {
        let uid = Auth.auth().currentUser!.uid
        gamelist.append(id ?? "")
        cartViewModel.addToCart(uid: uid, gamelist: gamelist)
    }
    
    var body: some View {
        let rating = Double(game.rating.reduce(0, +)) / Double(game.rating.count)
        if buy {
            CartView()
        } else {
            NavigationView {
                ZStack(alignment: .top) {
                    // Test only (admin)
                    ZStack {
                        Button {
                            checkUIDAndDelete()
                        } label: {
                            Text("Delete")
                        }
                    }
                    .zIndex(2)
                    CustomColor.primaryColor
                        .edgesIgnoringSafeArea(.all)
                    // Game image
                    AsyncImage(url: URL(string: game.imageURL)) {image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        CustomColor.secondaryColor.opacity(0.3)
                    }
                    .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: 300, alignment: .top)
                    .clipped()
                    .overlay(
                        RatingsView(rating: rating, color: CustomColor.starColor, width: 200)
                            .frame(maxHeight: .infinity, alignment: .bottom)
                            .padding(.bottom, 20)
                    )
                    .zIndex(1)
                    ZStack {
                        // Game price and buy
                        ZStack {
                            CustomColor.secondaryColor
                            VStack {
                                HStack {
                                    // Game price
                                    Text("$\(game.price, specifier: "%.2f")")
                                        .font(.system(size: 26))
                                        .multilineTextAlignment(.leading)
                                        .italic()
                                        .foregroundColor(CustomColor.lightDarkColor)
                                        .padding(.leading, 30)
                                    
                                    Spacer()
                                    
                                    // Buy button
                                    ForEach(cartViewModel.carts, id: \.id) { cart in
                                        if cart.uid == UID {
                                            Button {
                                                self.buy.toggle()
                                                getCart(gamelist: cart.gameID)
                                                addToCart(id: game.documentID)
                                            } label: {
                                                Text("Buy")
                                                    .font(.system(size: 20))
                                                    .fontWeight(.medium)
                                                
                                            }
                                            
                                        }
                                    }
                                    .frame(width: 80, height: 40, alignment: .center)
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
                    ScrollView {
                        VStack {
                            // Game name
                            HStack(alignment: .top) {
                                Text(game.name)
                                    .foregroundColor(CustomColor.secondaryColor)
                                    .font(.system(size: 24))
                                    .multilineTextAlignment(.leading)
                                    .fontWeight(.heavy)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Button {
                                    isFavorite.toggle()
                                } label: {
                                    if isFavorite {
                                        Image(systemName: "heart.fill")
                                            .font(isCompact ? .title : .largeTitle)
                                            .foregroundColor(CustomColor.heartColor)
                                    } else {
                                        Image(systemName: "heart")
                                            .font(isCompact ? .title : .largeTitle)
                                            .foregroundColor(CustomColor.heartColor)
                                    }
                                }
                            }
                            .padding(.top, 15)
                            .padding(.bottom, 5)
                            VStack {
                                // Game description
                                Text("Description")
                                    .foregroundColor(CustomColor.secondaryColor)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(.system(size: 20))
                                    .fontWeight(.bold)
                                Text(game.description)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .multilineTextAlignment(.leading)
                                    .font(.system(size: 18))
                                    .padding(.top, 1)
                            }
                            .padding(.bottom, 15)
                            VStack {
                                // Game publisher
                                HStack(alignment: .top) {
                                    Text("Developer")
                                        .foregroundColor(CustomColor.secondaryColor)
                                        .fontWeight(.medium)
                                        .frame(width: UIScreen.main.bounds.width / 4, alignment: .leading)
                                    Text(game.developer)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .padding(.bottom, 5)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                
                                // Game genre
                                HStack(alignment: .top) {
                                    if game.genre.count < 2 {
                                        Text("Genre")
                                            .foregroundColor(CustomColor.secondaryColor)
                                            .fontWeight(.medium)
                                            .frame(width: UIScreen.main.bounds.width / 4, alignment: .leading)
                                    } else {
                                        Text("Genres")
                                            .foregroundColor(CustomColor.secondaryColor)
                                            .fontWeight(.medium)
                                            .frame(width: UIScreen.main.bounds.width / 4, alignment: .leading)
                                    }
                                    Text(game.genre.joined(separator: ", "))
                                    
                                }
                                .padding(.bottom, 5)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                
                                // Game platform
                                HStack(alignment: .top) {
                                    if game.platform.count < 2 {
                                        Text("Platform")
                                            .foregroundColor(CustomColor.secondaryColor)
                                            .fontWeight(.medium)
                                            .frame(width: UIScreen.main.bounds.width / 4, alignment: .leading)
                                    } else {
                                        Text("Platforms")
                                            .foregroundColor(CustomColor.secondaryColor)
                                            .fontWeight(.medium)
                                            .frame(width: UIScreen.main.bounds.width / 4, alignment: .leading)
                                    }
                                    Text(game.platform.joined(separator: ", "))
                                    
                                }
                                .padding(.bottom, 5)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                
                            }
                            .font(.system(size: 18))
                            .multilineTextAlignment(.leading)
                            .padding(.bottom, 15)
                            VStack {
                                // Review list
                                Text("Reviews")
                                    .foregroundColor(CustomColor.secondaryColor)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(.system(size: 20))
                                    .fontWeight(.bold)
                                
                                // Review
                                VStack {
                                    HStack {
                                        Image("ava")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .clipShape(Circle())
                                            .frame(width: 50)
                                            .padding(.trailing, 20)
                                        VStack {
                                            Text("Monokuma")
                                                .fontWeight(.semibold)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            RatingsView(rating: 4, color: CustomColor.secondaryColor, width: 125)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                    }
                                    .padding(.bottom, 10)
                                    Text("Great execution.")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .padding()
                                .background(CustomColor.secondaryColor.opacity(isDark ? 0.3 : 0.2))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .padding(.bottom, 10)
                                VStack {
                                    HStack {
                                        Image("ava")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .clipShape(Circle())
                                            .frame(width: 50)
                                            .padding(.trailing, 20)
                                        VStack {
                                            Text("Monokuma")
                                                .fontWeight(.semibold)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            RatingsView(rating: 4, color: CustomColor.secondaryColor, width: 125)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                    }
                                    .padding(.bottom, 10)
                                    Text("Great execution.")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .padding()
                                .background(CustomColor.secondaryColor.opacity(isDark ? 0.3 : 0.2))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .padding(.bottom, 10)
                            }
                            .font(.system(size: 18))
                            .multilineTextAlignment(.leading)
                        }
                        .padding([.leading, .trailing, .bottom])
                    }
                    .padding(.top, 300)
                    .padding(.bottom, 40)
                }
                .overlay (
                    // MARK: - DISMISS GAME DETAIL BUTTON
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(isCompact ? .title : .largeTitle)
                    }
                        .foregroundColor(CustomColor.primaryColor)
                        .padding([.top, .leading], isCompact ? 20 : 30), alignment: .topLeading
                )
            }
            .environment(\.colorScheme, isDark ? .dark : .light)
        }
    }
}

struct GameDetailView_Previews: PreviewProvider {
    static var previews: some View {
        GameDetailView(game: .constant(Game(name: "Elden Ring", description: "Bruh.", price: 5.947 ,platform: ["PS4", "Xbox"], genre: ["Action", "RPG", "OpenWorld", "Soul-like"], developer: "FromSoftware", rating: [5,4,5,5,4,5], imageURL: "https://firebasestorage.googleapis.com/v0/b/ios-app-4da46.appspot.com/o/eldenring.jpg?alt=media&token=25132cbc-e9e2-432f-b072-5c04cf92183d", userID: "123456")), UID: "zhW4xMPXYya8nGiUSDNJ5AR1yiu2")
    }
}
