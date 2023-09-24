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
    @State var UID: String
    @Binding var gameList: [String]
    @StateObject var gameViewModel = GameViewModel()
    @StateObject var cartViewModel = CartViewModel()
    @State private var isFavorite: Bool = false
    
    func checkUIDAndDelete() {
        let uid = Auth.auth().currentUser!.uid
        if game.userID == uid {
            gameViewModel.removeGameData(documentID: game.documentID ?? "")
        }
    }
    func addToCart(id: String?) {
        let uid = Auth.auth().currentUser!.uid
        gameList.append(id ?? "")
        cartViewModel.addToCart(uid: uid, gamelist: gameList)
    }
    
    var body: some View {
        let rating = Double(game.rating.reduce(0, +)) / Double(game.rating.count)
        if buy {
            CartView()
        } else {
            NavigationView {
                ZStack(alignment: .top) {
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
                    .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: isCompact ? 300 : 450, alignment: .top)
                    .clipped()
                    .overlay(
                        RatingsView(rating: rating, color: CustomColor.starColor, width: isCompact ? 200 : 300)
                            .frame(maxHeight: .infinity, alignment: .bottom)
                            .padding(.bottom, isCompact ? 20 : 30)
                    )
                    .zIndex(1)
                    ZStack {
                        // Game price and buy
                        ZStack {
                            CustomColor.secondaryColor
                            VStack {
                                HStack(alignment: .center) {
                                    // Game price
                                    Text("$\(game.price, specifier: "%.2f")")
                                        .font(.system(size: isCompact ? 26 : 44))
                                        .multilineTextAlignment(.leading)
                                        .italic()
                                        .foregroundColor(CustomColor.lightDarkColor)
                                        .padding(.leading, isCompact ? 30 : 50)
                                    
                                    Spacer()
                                    
                                    // Buy button
                                    Button {
                                        self.buy.toggle()
                                        addToCart(id: game.documentID)
                                    } label: {
                                        Text("Buy")
                                            .font(.system(size: isCompact ? 20 : 34))
                                            .fontWeight(.medium)
                                    }
                                    .frame(width: isCompact ? 80 : 120, height: isCompact ? 40 : 60, alignment: .center)
                                    .background(CustomColor.primaryColor)
                                    .foregroundColor(CustomColor.darkLightColor)
                                    .cornerRadius(isCompact ? 10 : 20)
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
                    ScrollView {
                        VStack {
                            // Game name
                            HStack(alignment: .top) {
                                Text(game.name)
                                    .foregroundColor(CustomColor.secondaryColor)
                                    .font(.system(size: isCompact ? 24 : 40))
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
                            .padding(.top, isCompact ? 15 : 30)
                            .padding(.bottom, isCompact ? 5 : 10)
                            VStack {
                                // Game description
                                Text("Description")
                                    .foregroundColor(CustomColor.secondaryColor)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(.system(size: isCompact ? 20 : 34))
                                    .fontWeight(.bold)
                                Text(game.description)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .multilineTextAlignment(.leading)
                                    .font(.system(size: isCompact ? 18 : 30))
                                    .padding(.top, 1)
                            }
                            .padding(.bottom, isCompact ? 15 : 30)
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
                                .padding(.bottom, isCompact ? 5 : 10)
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
                                .padding(.bottom, isCompact ? 5 : 10)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                
                            }
                            .font(.system(size: isCompact ? 18 : 30))
                            .multilineTextAlignment(.leading)
                            .padding(.bottom, isCompact ? 15 : 30)
                            VStack {
                                // Review list
                                Text("Reviews")
                                    .foregroundColor(CustomColor.secondaryColor)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(.system(size: isCompact ? 20 : 34))
                                    .fontWeight(.bold)
                                
                                // Review
                                VStack {
                                    HStack {
                                        Image("ava")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .clipShape(Circle())
                                            .frame(width: isCompact ? 50 : 100)
                                            .padding(.trailing, isCompact ? 20 : 30)
                                        VStack {
                                            Text("Monokuma")
                                                .fontWeight(.semibold)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            RatingsView(rating: 4, color: CustomColor.secondaryColor, width: isCompact ? 125 : 175)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                    }
                                    .padding(.bottom, isCompact ? 10 : 20)
                                    Text("Great execution.")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .padding(isCompact ? 20 : 30)
                                .background(CustomColor.secondaryColor.opacity(isDark ? 0.3 : 0.2))
                                .clipShape(RoundedRectangle(cornerRadius: isCompact ? 10 : 20))
                                .padding(.bottom, isCompact ? 10 : 20)
                            }
                            .font(.system(size: isCompact ? 18 : 30))
                            .multilineTextAlignment(.leading)
                        }
                        .padding([.leading, .trailing, .bottom], isCompact ? 20 : 30)
                    }
                    .padding(.top, isCompact ? 300 : 450)
                    .padding(.bottom, isCompact ? 40 : 90)
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
                .overlay (
                    // MARK: - DELETE GAME BUTTON
                    Button(action: {
                        checkUIDAndDelete()
                    }) {
                        Image(systemName: "minus.circle.fill")
                            .font(isCompact ? .title : .largeTitle)
                    }
                        .foregroundColor(CustomColor.heartColor)
                        .padding([.top, .trailing], isCompact ? 20 : 30), alignment: .topTrailing
                )
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .environment(\.colorScheme, isDark ? .dark : .light)
        }
    }
}


struct GameDetailView_Previews: PreviewProvider {
    static var previews: some View {
        GameDetailView(game: .constant(Game(name: "Elden Ring", description: "Bruh.", price: 5.947 ,platform: ["PS4", "Xbox"], genre: ["Action", "RPG", "OpenWorld", "Soul-like"], developer: "FromSoftware", rating: [5,4,5,5,4,5], imageURL: "https://firebasestorage.googleapis.com/v0/b/ios-app-4da46.appspot.com/o/eldenring.jpg?alt=media&token=25132cbc-e9e2-432f-b072-5c04cf92183d", userID: "123456")), UID: "zhW4xMPXYya8nGiUSDNJ5AR1yiu2", gameList: .constant([
            "lVPwTATDwI14LyfnHvDO"]))
    }
}
