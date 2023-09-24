//
//  GameListRow.swift
//  DisplayGame
//
//  Created by Nguyễn Tuấn Thắng on 18/09/2023.
//

import SwiftUI
import Firebase

struct GameListRow: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    var isCompact: Bool {horizontalSizeClass == .compact}
    @State var game: Game
    var width: CGFloat
    var height: CGFloat
    
    var body: some View {
        let rating = Double(game.rating.reduce(0, +)) / Double(game.rating.count)
        VStack {
            AsyncImage(url: URL(string: game.imageURL)) // adding data from database
                .scaledToFill()
                .frame(width: width - 25, height: width - 25)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .clipped()
                .overlay(
                    Button(action: {
                        
                    }) {
                        Image(systemName: "heart")
                            .font(isCompact ? .title : .largeTitle)
                            .foregroundColor(CustomColor.heartColor)
                    }
                        .foregroundColor(CustomColor.primaryColor)
                        .padding([.top, .trailing], isCompact ? 10 : 20), alignment: .topTrailing
                )
            RatingsView(rating: rating, color: CustomColor.starColor, width: width - 75)
            // adding data from database
            Text(game.name)
                .font(.system(size: 18))
                .fontWeight(.medium)
                .foregroundColor(CustomColor.lightDarkColor)
                .multilineTextAlignment(.center)
            Text("$\(game.price, specifier: "%.2f")")
                .font(.system(size: 16))
                .italic()
                .foregroundColor(CustomColor.lightDarkColor)
                .multilineTextAlignment(.center)
        }
        .padding(10)
        .background(CustomColor.secondaryColor)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .frame(width: width, height: height)
    }
}

struct GameListRow_Previews: PreviewProvider {
    static var previews: some View {
        GameListRow(game: Game(name: "Elden Ring", description: "Bruh.", price: 5.947 ,platform: ["PS4", "Xbox"], genre: ["Action", "RPG", "OpenWorld", "Soul-like"], developer: "FromSoftware", rating: [5,4,5,5,4,5], imageURL: "https://firebasestorage.googleapis.com/v0/b/ios-app-4da46.appspot.com/o/eldenring.jpg?alt=media&token=25132cbc-e9e2-432f-b072-5c04cf92183d", userID: "123456"), width: 200, height: 300)
    }
}
