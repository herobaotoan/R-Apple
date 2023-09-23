//
//  GameListRow.swift
//  DisplayGame
//
//  Created by Nguyễn Tuấn Thắng on 18/09/2023.
//

import SwiftUI
import Firebase

struct GameListRow: View {
    
    // There is a need var to take data game from the database
    
    var body: some View {
        VStack{
            Image("game-product") // adding data from database
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 120, height: 120)
            RatingsView(rating: 4, color: CustomColor.secondaryColor, width: 125)
            // adding data from database
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("Name Game") // // adding data from database
        }
        .frame(width: 120, height: 170)
        .background()
        .border(.black)
        .cornerRadius(10)
    }
}

struct GameListRow_Previews: PreviewProvider {
    static var previews: some View {
        GameListRow()
    }
}
