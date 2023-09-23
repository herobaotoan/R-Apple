//
//  CartItemView.swift
//  R-GameHub
//
//  Created by Стивен on 23/09/2023.
//

import SwiftUI
import Firebase

struct CartItemView: View {
    @AppStorage("isDarkMode") private var isDark = false
    
    @State var game: Game
    @State var UID: String
    var body: some View {
        ZStack {
            HStack(alignment: .top) {
                AsyncImage(url: URL(string: game.imageURL))
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .padding(.trailing, 15)
                VStack {
                    Text("\(game.name)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(size: 20))
                        .fontWeight(.medium)
                        .padding(.bottom, 10)
                    Text("$\(game.price, specifier: "%.2f")")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .italic()
                        .font(.system(size: 16))
                }
                .multilineTextAlignment(.leading)
            }
        }
    }
}

struct CartItemView_Previews: PreviewProvider {
    static var previews: some View {
        CartItemView(game: Game(name: "Elden Rioweuhfosnfosnco eoclewojfboewcboweicnbng", description: "", price: 0 ,platform: ["PS4", "Xbox"], genre: ["Action", "RPG", "OpenWorld", "Soul-like"], developer: "FromSoftware", rating: [5,4,5,5,4,5], imageURL: "https://firebasestorage.googleapis.com/v0/b/ios-app-4da46.appspot.com/o/eldenring.jpg?alt=media&token=25132cbc-e9e2-432f-b072-5c04cf92183d", userID: "123456"), UID: "zhW4xMPXYya8nGiUSDNJ5AR1yiu2")
    }
}
