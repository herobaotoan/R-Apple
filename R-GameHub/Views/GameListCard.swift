//
//  GameListCard.swift
//  DisplayGame
//
//  Created by Nguyễn Tuấn Thắng on 18/09/2023.
//

import SwiftUI
import Firebase

struct GameListCard: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    var isCompact: Bool {horizontalSizeClass == .compact}
//    
//    @StateObject var gameViewModel = GameViewModel()
//    @StateObject var wishlistViewModel = WishlistViewModel()
//    @Binding var gameList: [String]
//    @Binding var UID: String
//    @State var isFavorite: Bool
    
    @State var game: Game
    var width: CGFloat
    var height: CGFloat
    
//    func checkIsFav() -> Bool {
//        for wishlist in wishlistViewModel.wishlists {
//            if wishlist.uid == UID {
//                for favorite in wishlist.gameID{
//                    if favorite == game.documentID {
//                        return favorite == game.documentID
//                    }
//                }
//            }
//        }
//        return false
//    }
//    
//    func addFavorite(id: String?) {
//        let uid = Auth.auth().currentUser!.uid
//        if !gameList.contains(id ?? ""){
//            gameList.append(id ?? "")
//        }
//        wishlistViewModel.newFavorite(uid: uid, gamelist: gameList)
//    }
//        
//    func removeFavorite(gameID: String) {
//        let uid = Auth.auth().currentUser!.uid
//        let wishlists = wishlistViewModel.wishlists
//        for wishlist in wishlistViewModel.wishlists {
//            if wishlist.uid == UID {
//                for favorite in wishlist.gameID{
//                    if !gameList.contains(favorite) {
//                        gameList.append(favorite)
//                    }
//                }
//            }
//        }
//        for wishlist in wishlists {
//            if wishlist.uid == uid {
//                let index = gameList.firstIndex(of: gameID) ?? 0
//                gameList.remove(at: index)
//                wishlistViewModel.updateWishlist(documentID: wishlist.documentID ?? "", gamelist: gameList)
//            }
//        }
//    }
    
    var body: some View {
        let rating = Double(game.rating.reduce(0, +)) / Double(game.rating.count)
        VStack {
            AsyncImage(url: URL(string: game.imageURL)) {image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                CustomColor.secondaryColor.opacity(0.3)
            }
            .frame(width: isCompact ? width - 25 : width - 75, height: isCompact ? width - 25 : width - 75)
            .clipShape(RoundedRectangle(cornerRadius: isCompact ? 15 : 30))
            .clipped()
            .overlay(
                Button(action: {
//                    self.isFavorite.toggle()
//                    checkIsFav() == false ? addFavorite(id: game.documentID) : removeFavorite(gameID: game.documentID ?? "")
                }) {
//                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                    Image(systemName: "heart")
                        .font(isCompact ? .title : .largeTitle)
                        .foregroundColor(CustomColor.heartColor)
                }
                    .foregroundColor(CustomColor.primaryColor)
                    .padding([.top, .trailing], 10), alignment: .topTrailing
            )
            RatingsView(rating: rating, color: CustomColor.starColor, width: isCompact ? width - 75 : width - 100)
            // adding data from database
            Text(game.name)
                .font(.system(size: isCompact ? 18 : 30))
                .fontWeight(.medium)
                .foregroundColor(CustomColor.lightDarkColor)
                .multilineTextAlignment(.center)
            Text("$\(game.price, specifier: "%.2f")")
                .font(.system(size: isCompact ? 16 : 26))
                .italic()
                .foregroundColor(CustomColor.lightDarkColor)
                .multilineTextAlignment(.center)
        }
        .padding(isCompact ? 10 : 20)
        .background(CustomColor.secondaryColor)
        .clipShape(RoundedRectangle(cornerRadius: isCompact ? 15 : 30))
        .frame(width: width, height: height)
    }
}

struct GameListCard_Previews: PreviewProvider {
    static var previews: some View {
//        GameListCard(gameList: .constant(["lVPwTATDwI14LyfnHvDO"]), UID: .constant("zhW4xMPXYya8nGiUSDNJ5AR1yiu2"), isFavorite: false, game: Game(name: "Elden Ring", description: "Bruh.", price: 5.947 ,platform: ["PS4", "Xbox"], genre: ["Action", "RPG", "OpenWorld", "Soul-like"], developer: "FromSoftware", rating: [5,4,5,5,4,5], imageURL: "https://firebasestorage.googleapis.com/v0/b/ios-app-4da46.appspot.com/o/eldenring.jpg?alt=media&token=25132cbc-e9e2-432f-b072-5c04cf92183d", userID: "123456"), width: 300, height: 400)
        GameListCard(game: Game(name: "Elden Ring", description: "Bruh.", price: 5.947 ,platform: ["PS4", "Xbox"], genre: ["Action", "RPG", "OpenWorld", "Soul-like"], developer: "FromSoftware", rating: [5,4,5,5,4,5], imageURL: "https://firebasestorage.googleapis.com/v0/b/ios-app-4da46.appspot.com/o/eldenring.jpg?alt=media&token=25132cbc-e9e2-432f-b072-5c04cf92183d", userID: "123456"), width: 300, height: 400)
    }
}
