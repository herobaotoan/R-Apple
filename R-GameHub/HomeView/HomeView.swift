//
//  HomeView.swift
//  DisplayGame
//
//  Created by Nguyễn Tuấn Thắng on 13/09/2023.
//

import SwiftUI

struct HomeView: View {
    
    @State var categories: [String] = ["Action", "Logic", "Magic"]  // Currentlt for test | This needs a function to take data from the database
    
    @State var searchText = ""
    
    @AppStorage("isDarkMode") private var isDark = false
    @State var loggingOut: Bool = false
    
    // Function for searching
    
    var body: some View {
        ZStack{
            if loggingOut {
                LogInView()
            } else {
                ZStack{
                    CustomColor.primaryColor
                        .edgesIgnoringSafeArea(.all)
                    VStack{
                        Menu{
                            Button{
                                // Something
                            } label: {
                                Text("Something")
                            }
                            
                            Button{
                                isDark.toggle()
                            } label: {
                                isDark ? Label("Dark", systemImage: "lightbulb.fill") : Label("Light", systemImage: "lightbulb")
                            }
                            
                            Button{
                                loggingOut = true
                            } label: {
                                Text("Log out")
                            }
                        }label: {
                            Text("User Name") //
                        }
                        
                        
                        TextField("Search", text: $searchText)
                            .foregroundColor(CustomColor.darkLightColor)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .cornerRadius(15)
                            .padding()
                            .overlay(
                                HStack{
                                  Image(systemName: "magnifyingglass")
                                        .padding(.trailing, 25)
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                }
                            )
                        
                        ScrollView{
                            ForEach(categories, id: \.self){ category in
                                VStack{
                                    Text(category).tag(category)
                                    
                                    // There is a need logic to display game following the category
//                                    if category == categories {
                                    GameListRow()
                                        .border(.black)
//                                    }
                                }
                                .padding()
                            }
                        }
                        
                    }   // VStack
                    
                }
                .environment(\.colorScheme, isDark ? .dark : .light)
            }
        }   // ZStack
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
