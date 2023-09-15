//
//  GameListRow.swift
//  DisplayGame
//
//  Created by Nguyễn Tuấn Thắng on 18/09/2023.
//

import SwiftUI

struct GameListRow: View {
    
    // There is a need var to take data game from the database
    
    var body: some View {
        ZStack{
            Button{
                // Game information
            }label: {
                ScrollView(.horizontal, showsIndicators: false){
                    HStack{
                        ForEach(0..<4){_ in 
                            VStack{
                                Image("Image")
                                    .resizable()
                                    .frame(width: 120, height: 120)
                                Text("Name Game")
                            }
                            .frame(width: 120, height: 150)
                            .background(.green)
                            .border(.black)
                            .cornerRadius(10)
                        }
                    }
                }
            }
        }
    }
}

struct GameListRow_Previews: PreviewProvider {
    static var previews: some View {
        GameListRow()
    }
}
