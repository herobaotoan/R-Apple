//
//  HomeView.swift
//  DisplayGame
//
//  Created by Nguyễn Tuấn Thắng on 13/09/2023.
//

import SwiftUI
import Firebase

struct HomeView: View {
    
    // Currentlt for test | This needs a function to take data from the database
    @State var selections: [String] = ["Home", "Wishlist"]
    @State private var selected = "Home"
    @State var genres: [String] = []
    
    @State var searchText = ""
    @StateObject var gameViewModel = GameViewModel()
    @Binding var UID: String
    
    @AppStorage("isDarkMode") private var isDark = false
    @State var loggingOut: Bool = false
    @State var isProfileView: Bool = false
    // Function for searching
    var body: some View {
        ZStack {
            if isProfileView {
                ProfileView(UID: $UID)
            } else if loggingOut {
                LogInView()
            } else {
                NavigationView {
                    let _ = loadGenre()
                    ZStack {
                        CustomColor.primaryColor
                            .edgesIgnoringSafeArea(.all)
                        VStack {
                            Button {
                                loadGenre()
                            } label: {
                                Text("Genre")
                            }
                            Menu {
                                Button {
                                    isProfileView = true
                                } label: {
                                    Text("Profile")
                                }
                                
                                Button {
                                    isDark.toggle()
                                } label: {
                                    isDark ? Label("Dark", systemImage: "lightbulb.fill") : Label("Light", systemImage: "lightbulb")
                                }
                                
                                Button {
                                    loggingOut = true
                                } label: {
                                    Text("Log out")
                                }
                            } label: {
                                Text("User Name") // adding data
                            }
                            
                            //  Search bar
                            TextField("Search", text: $searchText)
                                .foregroundColor(CustomColor.darkLightColor)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .cornerRadius(15)
                                .padding()
                                .overlay(
                                    HStack {
                                        Image(systemName: "magnifyingglass")
                                            .padding(.trailing, 25)
                                            .frame(maxWidth: .infinity, alignment: .trailing)
                                    }
                                )
                            
                            // Genres
                            Picker("genres" ,selection: $selected) {
                                ForEach(selections, id: \.self) {selection in
                                    Text(selection)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .padding(.horizontal)
                            
                            ScrollView {
                                ForEach(genres, id: \.self) {genre in
                                    Text(genre)
                                        .font(.system(size: 26))
                                        .fontWeight(.semibold)
                                        .foregroundColor(CustomColor.secondaryColor)
                                        .padding(.top, 10)
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        LazyHStack {
                                            ForEach(gameViewModel.games, id: \.id) {game in
                                                if game.genre.contains(genre) {
                                                    NavigationLink {
                                                        GameDetailView(game: .constant(game), UID: UID)
                                                            .navigationBarHidden(true)
                                                    } 
                                                    label: {
                                                        GameListRow(game: game)// adding data
                                                    }
                                                    .background(CustomColor.secondaryColor)
                                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                                                    .padding([.leading, .trailing], 10)
                                                }
                                            }
                                        }
                                    }
                                }
                                .frame(maxWidth: .infinity)
                            }
                        }   // VStack
                    }
                    .onAppear(perform: {
                        loadGenre()
                    })
                }
                .environment(\.colorScheme, isDark ? .dark : .light)
            }
        }
        .onAppear(perform: {
            self.loadGenre()
        })
    }
    func loadGenre() {
        for game in gameViewModel.games {
            for genre in game.genre {
                if !genres.contains(genre) {
                    genres.append(genre)
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(UID: .constant("zhW4xMPXYya8nGiUSDNJ5AR1yiu2"))
    }
}
