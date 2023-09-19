//
//  TestHomeView.swift
//  R-GameHub
//
//  Created by Toan Tran Chi on 19/09/2023.
//

import SwiftUI
import Firebase

struct TestHomeView: View {
    @StateObject var gameViewModel = GameViewModel()
    var genre = ""
    var body: some View {
        VStack {
            ForEach(gameViewModel.games, id: \.id) { game in
                Text(game.name)
                Text(game.developer)
                AsyncImage(url: URL(string: game.imageURL))
                    .scaledToFill()
                    .frame(width: 200, height: 200)
                    .clipped()
            }
        }
    }
}

struct TestHomeView_Previews: PreviewProvider {
    static var previews: some View {
        TestHomeView()
    }
}
