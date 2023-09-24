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
    @Binding var gamelist: [String]
    @State var UID: String
    @State var rev = ""
    @State var rat = ""
    @StateObject var gameViewModel = GameViewModel()
    @StateObject var cartViewModel = CartViewModel()
    @StateObject var reviewViewModel = ReviewViewModel()
    
    func checkUIDAndDelete () {
        let uid = Auth.auth().currentUser!.uid
        if game.userID == uid {
            gameViewModel.removeGameData(documentID: game.documentID ?? "")
        }
    }
    //REVIEW
    func addReview() {
        let uid = Auth.auth().currentUser!.uid
        var ratingList = game.rating
        ratingList.append(Int(rat) ?? 0)
        reviewViewModel.addNewReviewData(newReview: Review(description: rev, rating: Int(rat) ?? 0, userID: uid, gameID: game.documentID ?? ""))
        gameViewModel.updateGameRatinglist(documentID: game.documentID ?? "", ratingList: ratingList)
    }
    
    func addToCart (id: String?) {
        let uid = Auth.auth().currentUser!.uid
        gamelist.append(id ?? "")
        cartViewModel.addToCart(uid: uid, gamelist: gamelist)
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
            
            // REVIEW
            ForEach(reviewViewModel.reviews, id:\.id) { review in
                if review.gameID == game.documentID {
                    Text(String(review.rating))
                    Text(review.description)
                    Text(review.userID)
                }
            }
            HStack{
                TextField("Review: ", text: $rev)
                TextField("Rate: ", text: $rat)
                Button {
                    addReview()
                } label: {
                    Text("Add review")
                }
            }
        }
//        .onAppear() {
//            reviewViewModel.getGameReviewData(uid: game.documentID ?? "")
//
//        }
    }
}

//struct GameItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        GameItemView(game: Game(name: "Elden Ring", description: "", price: 0 ,platform: ["PS4", "Xbox"], genre: ["Action", "RPG", "OpenWorld", "Soul-like"], developer: "FromSoftware", rating: [5,4,5,5,4,5], imageURL: "https://firebasestorage.googleapis.com/v0/b/ios-app-4da46.appspot.com/o/eldenring.jpg?alt=media&token=25132cbc-e9e2-432f-b072-5c04cf92183d", userID: "123456"), gamelist: [""], UID: "zhW4xMPXYya8nGiUSDNJ5AR1yiu2")
//    }
//}
