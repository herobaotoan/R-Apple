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
    
    func checkUIDAndDelete () {
        let uid = Auth.auth().currentUser!.uid
        if game.userID == uid {
            gameViewModel.removeGameData(documentID: game.documentID ?? "")
        }
    }
    
    var body: some View {
        let rating = Double(game.rating.reduce(0, +)) / Double(game.rating.count)
        ZStack(alignment: .top) {
            // Game image
            CustomColor.primaryColor
                .edgesIgnoringSafeArea(.bottom)
            AsyncImage(url: URL(string: game.imageURL)) {image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                CustomColor.secondaryColor.opacity(0.3)
            }
                .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: 400, alignment: .top)
                .clipShape(
                    .rect(
                    topLeadingRadius: 0,
                    bottomLeadingRadius: 20,
                    bottomTrailingRadius: 20,
                    topTrailingRadius: 0
                    )
                )
                .overlay(
                    RatingsView(rating: rating, color: .yellow, width: 200)
                        .frame(maxHeight: .infinity, alignment: .bottom)
                        .padding(.bottom, 20)
                )
                .zIndex(1)
            
            // Test only (admin)
            ZStack {
                Button {
                    checkUIDAndDelete()
                } label: {
                    Text("Delete")
                }
            }
            .zIndex(2)
            ScrollView {
                VStack {
                    // Game name
                    Text(game.name)
                        .foregroundColor(CustomColor.secondaryColor)
                        .font(.system(size: 24))
                        .multilineTextAlignment(.center)
                        .fontWeight(.heavy)
                        .padding(.top, 15)
                        .padding(.bottom, 5)
                    
                    // Game price
                    Text("$19.99")
                        .font(.system(size: 22))
                        .multilineTextAlignment(.center)
                        .italic()
                        .padding(.bottom, 5)
                    VStack {
                        // Game description
                        Text("Description")
                            .foregroundColor(CustomColor.secondaryColor)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                        Text("Investigate murders, search for clues and talk to your classmates to prepare for trial. There, you'll engage in deadly wordplay, going back and forth with suspects. Dissect their statements and fire their words back at them to expose their lies! There's only one way to survive—pull the trigger.")
                            .multilineTextAlignment(.leading)
                            .font(.system(size: 18))
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
        }
        .overlay (
          
          // MARK: - DISMISS GAME DETAIL BUTTON
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "xmark.circle")
                    .font(isCompact ? .title : .largeTitle)
            }
              .foregroundColor(CustomColor.secondaryColor)
              .padding([.top, .trailing], isCompact ? 20 : 30), alignment: .topTrailing
        )
        .interactiveDismissDisabled()
        .environment(\.colorScheme, isDark ? .dark : .light)
    }
}

struct GameDetailView_Previews: PreviewProvider {
    static var previews: some View {
        GameDetailView(game: Game(name: "Elden Ring", platform: ["PS4", "Xbox"], genre: ["Action", "RPG", "OpenWorld", "Soul-like"], developer: "FromSoftware", rating: [5,4,5,5,4,5], imageURL: "https://firebasestorage.googleapis.com/v0/b/ios-app-4da46.appspot.com/o/eldenring.jpg?alt=media&token=25132cbc-e9e2-432f-b072-5c04cf92183d", userID: "123456"))
    }
}
