//
//  HomeView.swift
//  DisplayGame
//
//  Created by Nguyễn Tuấn Thắng on 13/09/2023.
//

import SwiftUI

struct HomeView: View {
    
    @State var categories: [String] = ["Action", "Logic", "Magic"]  // Currentlt for test | This needs a function to take data from the database
    
    
    @State var loggingOut: Bool = false
    
    var body: some View {
        ZStack{
            if loggingOut {
                LogInView()
            } else {
                VStack{
                    Menu{
                        Button{
                            // Something
                        } label: {
                            Text("Something")
                        }
                        
                        Button{
                            loggingOut = true
                        } label: {
                            Text("Log out")
                        }
                    }label: {
                        Text("User Name")
                    }
                    
                    ScrollView{
                        ForEach(categories, id: \.self){ category in
                            VStack{
                                Text(category).tag(category)
                                
                                // There is a need logic to display game following the category
                                //                             if category == categories {
                                GameListRow()
                                    .border(.black)
                                //                              }
                            }
                            .padding()
                        }
                    }
                    
                }   // VStack
            }
        }   // ZStack
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
