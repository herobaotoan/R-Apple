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
    @State var back: Bool = false
    @State var buy: Bool = false
    @State var isAddingReview: Bool = false
    @Binding var game: Game
    @Binding var UID: String
    @Binding var gameList: [String]
    @State var review = ""
    @State var rating: Int = 0
    @StateObject var gameViewModel = GameViewModel()
    @StateObject var cartViewModel = CartViewModel()
    @StateObject var reviewViewModel = ReviewViewModel()
    @State private var isFavorite: Bool = false
    let unselected = Image(systemName: "star")
    let selected = Image(systemName: "star.fill")
    
    func showStar(for number: Int) -> Image {
        if number > rating {
            return unselected
        } else {
            return selected
        }
    }
    
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
    
    func addReview() {
        let uid = Auth.auth().currentUser!.uid
        var ratingList = game.rating
        ratingList.append(Int(rating))
        reviewViewModel.addNewReviewData(newReview: Review(description: review, rating: Int(rating) , userID: uid, gameID: game.documentID ?? ""))
        gameViewModel.updateGameRatinglist(documentID: game.documentID ?? "", ratingList: ratingList)
    }
    
    var body: some View {
        let totalRating = Double(game.rating.reduce(0, +)) / Double(game.rating.count)
        if buy {
            CartView(UID: $UID)
        } else if back {
            HomeView(UID: $UID)
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
                        RatingsView(rating: totalRating, color: CustomColor.starColor, width: isCompact ? 200 : 300)
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
                                    .overlay(
                                        Button(action: {
                                            isAddingReview = true
                                        }) {
                                            Image(systemName: "plus.circle.fill")
                                                .font(isCompact ? .title : .largeTitle)
                                        }
                                            .foregroundColor(CustomColor.secondaryColor), alignment: .trailing
                                    )
                                
                                // Review
                                ForEach(reviewViewModel.reviews, id:\.id) {review in
                                    if review.gameID == game.documentID {
                                        VStack {
                                            HStack {
                                                Image("ava") // User ava
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .clipShape(Circle())
                                                    .frame(width: isCompact ? 50 : 100)
                                                    .padding(.trailing, isCompact ? 20 : 30)
                                                VStack {
                                                    Text("Monokuma") // User name
                                                        .fontWeight(.semibold)
                                                        .frame(maxWidth: .infinity, alignment: .leading)
                                                    RatingsView(rating: Double(review.rating), color: CustomColor.secondaryColor, width: isCompact ? 125 : 175)
                                                        .frame(maxWidth: .infinity, alignment: .leading)
                                                }
                                            }
                                            .padding(.bottom, isCompact ? 10 : 20)
                                            Text(review.description)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                        .padding(isCompact ? 20 : 30)
                                        .background(CustomColor.secondaryColor.opacity(isDark ? 0.3 : 0.2))
                                        .clipShape(RoundedRectangle(cornerRadius: isCompact ? 10 : 20))
                                        .padding(.bottom, isCompact ? 10 : 20)
                                    }
                                }
                            }
                            .font(.system(size: isCompact ? 18 : 30))
                            .multilineTextAlignment(.leading)
                        }
                        .padding([.leading, .trailing, .bottom], isCompact ? 20 : 30)
                    }
                    .padding(.top, isCompact ? 300 : 450)
                    .padding(.bottom, isCompact ? 40 : 90)
                    
                    if isAddingReview {
                        let color = CustomColor.secondaryColor
                        ZStack {
                            CustomColor.shadowColor
                                .edgesIgnoringSafeArea(.all)
                            VStack {
                                Text("Add Review")
                                    .font(.system(size: isCompact ? 24 : 40))
                                    .fontWeight(.semibold)
                                    .foregroundColor(CustomColor.secondaryColor)
                                HStack {
                                    ForEach(1...5, id: \.self) {number in
                                        showStar(for: number)
                                            .foregroundColor(number <= rating ? color : color.opacity(0.3))
                                            .onTapGesture {
                                                rating = number
                                            }
                                    }
                                    .font(.system(size: isCompact ? 30: 60))
                                }
                                .padding([.top, .bottom], isCompact ? 20 : 30)
                                HStack {
                                    Image(systemName: "pencil.line")
                                        .font(isCompact ? .title : .largeTitle)
                                        .padding(isCompact ? 10 : 20)
                                        .foregroundColor(CustomColor.secondaryColor)
                                    VStack {
                                        TextField("Review", text: self.$review, axis: .vertical)
                                            .font(.system(size: isCompact ? 20 : 34))
                                        Divider()
                                            .background(CustomColor.secondaryColor)
                                    }
                                }
                                
                                Button {
                                    addReview()
                                    isAddingReview = false
                                } label: {
                                    Text("Add")
                                        .fontWeight(.medium)
                                        .font(.system(size: isCompact ? 20 : 34))
                                        .frame(width: isCompact ? 80 : 120, height: isCompact ? 50 : 80, alignment: .center)
                                        .background(CustomColor.secondaryColor)
                                        .foregroundColor(CustomColor.lightDarkColor)
                                        .cornerRadius(isCompact ? 10 : 20)
                                        .shadow(color: .black, radius: isCompact ? 2 : 4)
                                        .padding(isCompact ? 15 : 25)
                                }
                            }
                            .padding(isCompact ? 20 : 30)
                            .frame(width: isCompact ? 350 : 600, height: isCompact  ? 300 : 550)
                            .background(CustomColor.lightDarkColor)
                            .cornerRadius(isCompact ? 15 : 30)
                            .overlay (
                                // MARK: - DISMISS ADD REVIEW POPUP
                                Button(action: {
                                    isAddingReview = false
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(isCompact ? .title : .largeTitle)
                                }
                                    .foregroundColor(CustomColor.secondaryColor)
                                    .padding([.top, .leading], isCompact ? 20 : 30), alignment: .topLeading
                            )
                        }
                        .zIndex(4)
                    }
                }
                .overlay (
                    // MARK: - DISMISS GAME DETAIL BUTTON
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(isCompact ? .title : .largeTitle)
                    }
                        .foregroundColor(CustomColor.secondaryColor)
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
        GameDetailView(game: .constant(Game(name: "Elden Ring", description: "Bruh.", price: 5.947 ,platform: ["PS4", "Xbox"], genre: ["Action", "RPG", "OpenWorld", "Soul-like"], developer: "FromSoftware", rating: [5,4,5,5,4,5], imageURL: "https://firebasestorage.googleapis.com/v0/b/ios-app-4da46.appspot.com/o/eldenring.jpg?alt=media&token=25132cbc-e9e2-432f-b072-5c04cf92183d", userID: "123456")), UID: .constant("zhW4xMPXYya8nGiUSDNJ5AR1yiu2"), gameList: .constant([
            "lVPwTATDwI14LyfnHvDO"]))
    }
}
