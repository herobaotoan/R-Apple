//
//  HomeView.swift
//  DisplayGame
//
//  Created by Nguyễn Tuấn Thắng on 13/09/2023.
//

import SwiftUI
import Firebase

struct HomeView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    var isCompact: Bool {horizontalSizeClass == .compact}
    
    @AppStorage("isDarkMode") private var isDark = false

    @State var selections = ["Home", "Wishlist"]
    @State private var selected = "Home"
    @State var genres: [String] = []
    
    @State var searchText = ""
    @StateObject var gameViewModel = GameViewModel()
    @StateObject var userViewModel = UserViewModel()
    @StateObject var cartViewModel = CartViewModel()
    @Binding var UID: String
    @State var loggingOut: Bool = false
    @State var isProfileView: Bool = false
    
    @State var cart: [String] = [""]
    func getCart(item: Cart){
        cart = item.gameID
    }
    
    var filteredGame: [Game] {
        if searchText.isEmpty {
            return gameViewModel.games
        } else {
            return gameViewModel.games.filter({$0.name.localizedCaseInsensitiveContains(searchText)})
        }
    }
    func show() {
        self.userViewModel.getUserData(UID: UID)
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

    // Function for searching
    var body: some View {
        ZStack {
            if isProfileView {
                ProfileView(UID: $UID)
            } else if loggingOut {
                LogInView()
            } else {
                let _ =  DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                    loadGenre()
                    show()
                }
                NavigationView {
                    ZStack {
                        CustomColor.primaryColor
                            .edgesIgnoringSafeArea(.all)
                        VStack {
                            Menu {
                                Button {
                                    isProfileView = true
                                } label: {
                                    ForEach(userViewModel.user, id: \.uid) { user in
                                        Label(user.name, systemImage: "person.circle")
                                    }
                                }
                                
                                Button {
                                    isDark.toggle()
                                } label: {
                                    isDark ? Label("Dark", systemImage: "lightbulb.fill") : Label("Light", systemImage: "lightbulb")
                                }
                                
                                Button {
                                    loggingOut = true
                                } label: {
                                    Label("Log out", systemImage: "minus.circle")
                                }
                                .tint(.red)
                            } label: {
                                Image(systemName: "person.fill")
                                    .foregroundColor(CustomColor.secondaryColor)
                                    .font(isCompact ? .title : .largeTitle)
                                    .fontWeight(.bold)
                            }
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.trailing, 20)
                            .overlay(
                                Text("R-GameHub")
                                    .foregroundColor(CustomColor.secondaryColor)
                                    .font(.system(size: 24))
                                    .fontWeight(.bold)
                            )
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
                            if searchText.isEmpty {
                                // Genres
                                Picker("Selection" ,selection: $selected) {
                                    ForEach(selections, id: \.self) {selection in
                                        Text(selection)
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                                .padding(.horizontal)
                                ScrollView {
                                    if selected == "Home" {
                                        ForEach(genres, id: \.self) {genre in
                                            Text(genre)
                                                .font(.system(size: 26))
                                                .fontWeight(.medium)
                                                .foregroundColor(CustomColor.secondaryColor)
                                                .padding(.top, 10)
                                            ScrollView(.horizontal, showsIndicators: false) {
                                                LazyHStack {
                                                    ForEach(gameViewModel.games, id: \.id) {game in
                                                        if game.genre.contains(genre) {
                                                            NavigationLink {
                                                                GameDetailView(game: .constant(game), UID: UID, gamelist: $cart)
                                                                    .navigationBarHidden(true)
                                                            }
                                                            label: {
                                                                GameListRow(game: game, width: 200, height: 300)
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
                                    } else if selected == "Wishlist" {
                                        Text("Hi")
                                    }
                                }
                            } else {
                                LazyVGrid(columns: [GridItem(.flexible(), spacing: 15),
                                                    GridItem(.flexible(), spacing: 15)]) {
                                    ForEach(filteredGame, id: \.id) {game in
                                        NavigationLink {
                                            GameDetailView(game: .constant(game), UID: UID, gamelist: $cart)
                                                .navigationBarHidden(true)
                                        }
                                        label: {
                                            GameListRow(game: game, width: 175, height: 250)
                                        }
                                        .background(CustomColor.secondaryColor)
                                        .clipShape(RoundedRectangle(cornerRadius: 15))
                                    }
                                    ForEach(cartViewModel.carts, id: \.id) { carts in
                                        Text("")
                                            .onAppear() {
                                                getCart(item: carts)
                                            }
                                    }
                                }
                                Spacer()
                            }
                        }
                    }
                }
                .environment(\.colorScheme, isDark ? .dark : .light)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(UID: .constant("zhW4xMPXYya8nGiUSDNJ5AR1yiu2"))
    }
}
