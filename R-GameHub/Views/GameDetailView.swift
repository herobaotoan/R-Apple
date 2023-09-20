//
//  GameDetail.swift
//  R-GameHub
//
//  Created by Стивен on 19/09/2023.
//

import SwiftUI

struct GameDetailView: View {
    var body: some View {
        ZStack {
            CustomColor.primaryColor
                .edgesIgnoringSafeArea(.all)
            VStack {
                // Game image
                Image("game-product")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 250, height: 250)
                    .padding()
                // Game name
                Text("Danganronpa: Trigger Happy Havoc")
                // Game publisher
                Text("Publisher: Spike Chunsoft Co., Ltd.")
                // Game genre
                Text("Genre: Adventure")
                // Game price
                Text("$19.99")
                Spacer()
                // Game description
                Text("Description")
                Text("Investigate murders, search for clues and talk to your classmates to prepare for trial. There, you'll engage in deadly wordplay, going back and forth with suspects. Dissect their statements and fire their words back at them to expose their lies! There's only one way to survive—pull the trigger.")
                Spacer()
                // Review
                Text("Reviews")
//                ForEach(reviews) {review in
//                    HStack {
//                        Text("User: \(review.user.name)")
//                        Text(review.description)
//                        RatingsView(rating: review.score)
//                            .frame(width: 150)
//                    }
//                }
            }
        }
    }
}

struct GameDetailView_Previews: PreviewProvider {
    static var previews: some View {
        GameDetailView()
    }
}
