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
    
    @State var game: Game
    @StateObject var gameViewModel = GameViewModel()
    @State private var itemCount: Int = 1
    
    func checkUIDAndDelete () {
        let uid = Auth.auth().currentUser!.uid
        if game.userID == uid {
            gameViewModel.removeGameData(documentID: game.documentID ?? "")
        }
    }
    
    var body: some View {
        let rating = Double(game.rating.reduce(0, +)) / Double(game.rating.count)
        let totalPrice = round(game.price * Double(itemCount) * 100) / 100.0
        
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
                .edgesIgnoringSafeArea(.bottom)
            // Game image
            AsyncImage(url: URL(string: game.imageURL)) {image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                CustomColor.secondaryColor.opacity(0.3)
            }
                .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: 400, alignment: .top)
                .overlay(
                    RatingsView(rating: rating, color: .yellow, width: 200)
                        .frame(maxHeight: .infinity, alignment: .bottom)
                        .padding(.bottom, 20)
                )
                .zIndex(1)
            
            ZStack {
                // Game price and buy
                ZStack {
                    CustomColor.secondaryColor
                    HStack {
                        // Game price
                        Text("$\(totalPrice, specifier: "%.2f")")
                            .font(.system(size: 26))
                            .multilineTextAlignment(.leading)
                            .italic()
                            .foregroundColor(CustomColor.lightDarkColor)
                            .padding(.leading, 30)
                        
                        Spacer()
                        
                        // Buy button
                        Button {
                            
                        } label: {
                            Text("Buy")
                                .font(.system(size: 20))
                                .fontWeight(.medium)
                        }
                        .frame(width: 80, height: 40, alignment: .center)
                        .background(CustomColor.primaryColor)
                        .foregroundColor(CustomColor.darkLightColor)
                        .cornerRadius(10)
                        .padding(.trailing, 30)
                    }
                    .overlay(
                        // Game item number adjust
                        HStack {
                            Button {
                                if itemCount > 1 {
                                    itemCount -= 1
                                }
                            } label: {
                                Text("-")
                                    .foregroundColor(CustomColor.darkLightColor)
                            }
                            .frame(width: 30, height: 30, alignment: .center)
                            .background(CustomColor.primaryColor)
                            .foregroundColor(CustomColor.darkLightColor)
                            .cornerRadius(10)
                            Text("\(itemCount)")
                                .font(.system(size: 26))
                                .foregroundColor(CustomColor.lightDarkColor)
                                .padding([.leading, .trailing], 5)
                            Button {
                                itemCount += 1
                            } label: {
                                Text("+")
                                    .foregroundColor(CustomColor.darkLightColor)
                            }
                            .frame(width: 30, height: 30, alignment: .center)
                            .background(CustomColor.primaryColor)
                            .foregroundColor(CustomColor.darkLightColor)
                            .cornerRadius(10)
                        }
                    )
                }
                .frame(height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .ignoresSafeArea()
            .zIndex(2)
            ScrollView {
                VStack {
                    // Game name
                    Text(game.name)
                        .foregroundColor(CustomColor.secondaryColor)
                        .font(.system(size: 24))
                        .multilineTextAlignment(.leading)
                        .fontWeight(.heavy)
                        .frame(maxWidth: .infinity, alignment: .leading)
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
                            HStack(alignment: .center) {
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
                        .background(CustomColor.secondaryColor.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.bottom, 10)
                        VStack {
                            HStack(alignment: .center) {
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
                        .background(CustomColor.secondaryColor.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.bottom, 10)
                    }
                    .font(.system(size: 18))
                    .multilineTextAlignment(.leading)
                }
                .padding([.leading, .trailing, .bottom])
            }
            .padding(.top, 400)
            .padding(.bottom, 30)
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
              .padding([.top, .trailing], isCompact ? 20 : 30), alignment: .topTrailing
        )
        .interactiveDismissDisabled()
        .environment(\.colorScheme, isDark ? .dark : .light)
    }
}

struct GameDetailView_Previews: PreviewProvider {
    static var previews: some View {
        GameDetailView(game: Game(name: "Elden Ring", description: "Bruh.", price: 5.947 ,platform: ["PS4", "Xbox"], genre: ["Action", "RPG", "OpenWorld", "Soul-like"], developer: "FromSoftware", rating: [5,4,5,5,4,5], imageURL: "https://firebasestorage.googleapis.com/v0/b/ios-app-4da46.appspot.com/o/eldenring.jpg?alt=media&token=25132cbc-e9e2-432f-b072-5c04cf92183d", userID: "123456"))
    }
}
