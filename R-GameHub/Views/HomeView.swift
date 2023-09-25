/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2023B
  Assessment: Assignment 3
  Author: R-Apple (Bui Nguyen Ngoc Tuan | Vo Tran Khanh Linh | Tran Chi Toan | Nguyen Thi Ha Giang | Nguyen Tuan Thang)
  ID: s3877673 | s3878600 | s3891637 | s3914108 | s3877039
  Created  date: 15/09/2023
  Last modified: 25/09/2023
  Acknowledgement: Previous assignments of members | Firebase lectures on Canvas | YouTube | Stackoverflow
*/

import SwiftUI
import Firebase
import FirebaseStorage

struct HomeView: View {
    // MARK: - DECLARE VARIABLES
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    var isCompact: Bool {horizontalSizeClass == .compact}
    
    @AppStorage("isDarkMode") private var isDark = false

    let storage: Storage = Storage.storage()
    @State var image: UIImage?
    @State var loginStatusMessage = ""
    @State var imageURL = ""
    @State var priceString = ""
    @State var price: Double = 0.0
    @State var name = ""
    @State var developer = ""
    @State var description = ""
    @State var genreText = ""
    @State var genresToAdd : [String] = []
    @State var platformText = ""
    @State var platforms : [String] = []
    @State var selections = ["Home", "Wishlist"]
    @State private var selected = "Home"
    @State var genres: [String] = []
    @State var isAddingGame: Bool = false
    @State var shouldShowImagePicker = false
    @State var searchText = ""
    @StateObject var gameViewModel = GameViewModel()
    @StateObject var userViewModel = UserViewModel()
    @StateObject var cartViewModel = CartViewModel()
    @StateObject var wishlistViewModel = WishlistViewModel()
    @Binding var UID: String
    @State var isProfileView: Bool = false
    @State var isCartView: Bool = false
    @State var cart: [String] = []
    @State var wishlist: [String] = []
    
    // MARK: - GET WISH LIST OF CURRENT USER
    func getFavoriteList() -> [Game] {
        var ownWishlist: [Game] = []
            for wishlist in wishlistViewModel.wishlists {
                if wishlist.uid == UID {
                    for favorite in wishlist.gameID{
                        for game in gameViewModel.games {
                            if game.documentID ?? "" == favorite {
                                ownWishlist.append(game)
                            }
                        }
                    }
                }
            }
            return ownWishlist
    }
    
    
    // MARK: - GET CART OF CURRENT USER
    func getCart(item: Cart) {
        if item.gameID.count >= cart.count {
            cart = item.gameID
        }
    }
    
    // MARK: - FILTER GAME
    var filteredGame: [Game] {
        if searchText.isEmpty {
            return gameViewModel.games
        } else {
            return gameViewModel.games.filter({$0.name.localizedCaseInsensitiveContains(searchText)})
        }
    }
//    func show() {
//        self.userViewModel.getUserData(UID: UID)
//    }
    
    // MARK: - LOAD GENRE GAME
    func loadGenre() {
        for game in gameViewModel.games {
            for genre in game.genre {
                if !genres.contains(genre) {
                    genres.append(genre)
                }
            }
        }
    }
    
    // MARK: - UPLOAD IMAGE TO DATABASE
    func upload() {
        persistImageToStorage()
    }
    
    // MARK: - STORE IMAGE TO DATABASE
    private func persistImageToStorage() {
        let uid = Auth.auth().currentUser!.uid
        let ref = storage.reference(withPath: uid).child("images/\(Int.random(in: 1..<999999))")
        print("Helo")
        guard let imageData = self.image?.jpegData(compressionQuality: 0.5) else { return }
        ref.putData(imageData, metadata: nil) { metadata, err in
            if let err = err {
                    self.loginStatusMessage = "Failed to push image to Storage: \(err)"
                return
            }
            ref.downloadURL { url, err in
                if let err = err {
                        self.loginStatusMessage = "Failed to retrieve downloadURL: \(err)"
                    return
                }
                imageURL = url?.absoluteString ?? ""
                price = Double(priceString)!
                gameViewModel.addNewGameData(newGame: Game(name: name, description: description, price: price, platform: platforms, genre: genresToAdd, developer: developer, rating: [5], imageURL: imageURL, userID: uid))
                    self.loginStatusMessage = "Successfully Added Game"
            }
        }
    }

    // Function for searching
    var body: some View {
        ZStack {
            // MARK: - NAVIGATE TO PROFILE VIEW
            if isProfileView {
                ProfileView(UID: $UID)
            } else if isCartView {
                CartView(UID: $UID)
                
            // MARK: - HOME VIEW
            } else {
                let _ =  DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                    loadGenre()
                }
                NavigationView {
                    ZStack {
                        CustomColor.primaryColor
                            .edgesIgnoringSafeArea(.all)
                        ForEach(cartViewModel.carts, id: \.id) {carts in
                            Text("")
                                .onAppear() {
                                    getCart(item: carts)
                                }
                        }
                        VStack {
                            HStack {
                                // MARK: - BUTTON ADD NEW GAME
                                Button {
                                    isAddingGame = true
                                } label: {
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundColor(CustomColor.secondaryColor)
                                        .font(isCompact ? .title : .largeTitle)
                                        .fontWeight(.bold)
                                }
                                .padding(.leading, isCompact ? 20 : 30)
                                Menu {
                                    Button {
                                        isProfileView = true
                                    } label: {
                                        ForEach(userViewModel.user, id: \.uid) { user in
                                            if user.id == UID {
                                                Label("\(user.name)", systemImage: "person.circle")
                                            }
                                        }
                                    }
                                    
                                    Button {
                                        isDark.toggle()
                                    } label: {
                                        isDark ? Label("Dark", systemImage: "lightbulb.fill") : Label("Light", systemImage: "lightbulb")
                                    }
                                } label: {
                                    Image(systemName: "person.fill")
                                        .foregroundColor(CustomColor.secondaryColor)
                                        .font(isCompact ? .title : .largeTitle)
                                        .fontWeight(.bold)
                                }
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .padding(.trailing, isCompact ? 20 : 30)
                            }
                            .overlay(
                                Text("R-GameHub")
                                    .foregroundColor(CustomColor.secondaryColor)
                                    .font(.system(size: isCompact ? 28 : 48))
                                    .fontWeight(.bold)
                            )
                            //  Search bar
                            TextField("Search", text: $searchText)
                                .foregroundColor(CustomColor.darkLightColor)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .cornerRadius(isCompact ? 15 : 25)
                                .padding(isCompact ? 20 : 30)
                                .overlay(
                                    HStack {
                                        Image(systemName: "magnifyingglass")
                                            .padding(.trailing, isCompact ? 25 : 40)
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
                                                .font(.system(size: isCompact ? 26 : 44))
                                                .fontWeight(.medium)
                                                .foregroundColor(CustomColor.secondaryColor)
                                                .padding(.top, isCompact ? 10 : 20)
                                            ScrollView(.horizontal, showsIndicators: false) {
                                                LazyHStack {
                                                    ForEach(gameViewModel.games, id: \.id) {game in
                                                        if game.genre.contains(genre) {
                                                            NavigationLink {
                                                                GameDetailView(game: .constant(game), UID: $UID, gameList: $cart)
                                                                    .navigationBarHidden(true)
                                                            }
                                                            label: {
                                                                GameListCard(gameList: $wishlist, UID: $UID, isFavorite: false, game: game, width: isCompact ? 200 : 300, height: isCompact ? 300 : 400)
                                                            }
                                                            .background(CustomColor.secondaryColor)
                                                            .clipShape(RoundedRectangle(cornerRadius: isCompact ? 15 : 30))
                                                            .padding([.leading, .trailing], isCompact ? 10 : 20)
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        .frame(maxWidth: .infinity)
                                        
                                        // MARK: - TURN TO WISHLIST TAB
                                    } else if selected == "Wishlist" {
//                                        getFavoriteList()
                                        LazyVGrid(columns: [GridItem(.flexible(), spacing: isCompact ? 15 : 30),
                                                            GridItem(.flexible(), spacing: isCompact ? 15 : 30)]) {
                                            
                                            ForEach(getFavoriteList(), id: \.id) { game in
                                                NavigationLink {
                                                    GameDetailView(game: .constant(game), UID: $UID, gameList: $wishlist)
                                                        .navigationBarHidden(true)
                                                }
                                                label: {
                                                GameListCard(gameList: $wishlist, UID: $UID, isFavorite: false, game: game, width: isCompact ? 175 : 325, height: isCompact ? 250 : 450)
                                                }
                                                .background(CustomColor.secondaryColor)
                                                .clipShape(RoundedRectangle(cornerRadius: isCompact ? 15 : 30))
                                            }
                                            
                                        }
                                        Spacer()
                                    }
                                }
                            } else {
                                // MARK: - DISPLAY GAME CARD
                                LazyVGrid(columns: [GridItem(.flexible(), spacing: isCompact ? 15 : 30),
                                                    GridItem(.flexible(), spacing: isCompact ? 15 : 30)]) {
                                    ForEach(filteredGame, id: \.id) {game in
                                        NavigationLink {
                                            GameDetailView(game: .constant(game), UID: $UID, gameList: $cart)
                                                .navigationBarHidden(true)
                                        }
                                        label: {
                                            GameListCard(gameList: $wishlist, UID: $UID, isFavorite: false, game: game, width: isCompact ? 175 : 325, height: isCompact ? 250 : 450)
                                        }
                                        .background(CustomColor.secondaryColor)
                                        .clipShape(RoundedRectangle(cornerRadius: isCompact ? 15 : 30))
                                    }
                                }
                                Spacer()
                            }
                        }
                        // MARK: - ADDING GAME VIEW
                        if isAddingGame {
                            ZStack {
                                CustomColor.shadowColor
                                    .edgesIgnoringSafeArea(.all)
                                VStack {
                                    Group {
                                        Text("Add Game")
                                            .font(.system(size: isCompact ? 24 : 40))
                                            .fontWeight(.semibold)
                                            .foregroundColor(CustomColor.secondaryColor)
                                        Button {
                                            shouldShowImagePicker.toggle()
                                        } label: {
                                            VStack {
                                                if let image = self.image {
                                                    Image(uiImage: image)
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: isCompact ? 100 : 125, height: isCompact ? 100 : 125)
                                                        .clipShape(RoundedRectangle(cornerRadius: isCompact ? 10 : 20))
                                                } else {
                                                    Image(systemName: "photo.fill")
                                                        .font(.system(size: isCompact ? 100 : 125))
                                                        .foregroundColor(CustomColor.secondaryColor)
                                                }
                                            }
                                            .padding(isCompact ? 5 : 10)
                                        }
                                    }
                                    
                                    Group {
                                        HStack {
                                            Image(systemName: "dpad.up.filled")
                                                .font(isCompact ? .title : .largeTitle)
                                                .padding(isCompact ? 10 : 20)
                                                .foregroundColor(CustomColor.secondaryColor)
                                            VStack {
                                                TextField("Name", text: $name)
                                                    .font(.system(size: isCompact ? 20 : 34))
                                                Divider()
                                                    .background(CustomColor.secondaryColor)
                                            }
                                        }
                                        HStack {
                                            Image(systemName: "person.fill")
                                                .font(isCompact ? .title : .largeTitle)
                                                .padding(isCompact ? 10 : 20)
                                                .foregroundColor(CustomColor.secondaryColor)
                                            VStack {
                                                TextField("Developer", text: $developer)
                                                    .font(.system(size: isCompact ? 20 : 34))
                                                Divider()
                                                    .background(CustomColor.secondaryColor)
                                            }
                                        }
                                        HStack {
                                            Image(systemName: "pencil.line")
                                                .font(isCompact ? .title : .largeTitle)
                                                .padding(isCompact ? 10 : 20)
                                                .foregroundColor(CustomColor.secondaryColor)
                                            VStack {
                                                TextField("Description", text: $description, axis: .vertical)
                                                    .font(.system(size: isCompact ? 20 : 34))
                                                Divider()
                                                    .background(CustomColor.secondaryColor)
                                            }
                                        }
                                        HStack {
                                            Image(systemName: "dollarsign.circle.fill")
                                                .font(isCompact ? .title : .largeTitle)
                                                .padding(isCompact ? 10 : 20)
                                                .foregroundColor(CustomColor.secondaryColor)
                                            VStack {
                                                TextField("Price", text: $priceString).keyboardType(.decimalPad)
                                                    .font(.system(size: isCompact ? 20 : 34))
                                                Divider()
                                                    .background(CustomColor.secondaryColor)
                                            }
                                        }
                                        HStack {
                                            Image(systemName: "")
                                                .font(isCompact ? .title : .largeTitle)
                                                .padding(isCompact ? 10 : 20)
                                                .foregroundColor(CustomColor.secondaryColor)
                                            VStack {
                                                TextField("Genre", text: $genreText, axis: .vertical)
                                                    .font(.system(size: isCompact ? 20 : 34))
                                                Divider()
                                                    .background(CustomColor.secondaryColor)
                                            }
                                            Button {
                                                genresToAdd.append(genreText)
                                                genreText = ""
                                                
                                            } label : {
                                                Image(systemName: "plus.circle.fill")
                                                    .font(isCompact ? .title : .largeTitle)
                                                    .padding(isCompact ? 10 : 20)
                                                    .foregroundColor(CustomColor.secondaryColor)
                                            }
                                        }
                                        Text("Genre: \(genresToAdd.joined(separator: ", "))")
                                            .padding(.leading, 10)
                                            .font(.system(size: isCompact ? 20 : 34))
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        HStack {
                                            Image(systemName: "rectangle.on.rectangle.circle.fill")
                                                .font(isCompact ? .title : .largeTitle)
                                                .padding(isCompact ? 10 : 20)
                                                .foregroundColor(CustomColor.secondaryColor)
                                            VStack {
                                                TextField("Platform", text: $platformText)
                                                    .font(.system(size: isCompact ? 20 : 34))
                                                Divider()
                                                    .background(CustomColor.secondaryColor)
                                            }
                                            Button {
                                                platforms.append(platformText)
                                                platformText = ""
                                                
                                            } label : {
                                                Image(systemName: "plus.circle.fill")
                                                    .font(isCompact ? .title : .largeTitle)
                                                    .padding(isCompact ? 10 : 20)
                                                    .foregroundColor(CustomColor.secondaryColor)
                                            }
                                        }
                                        Text("Platform: \(platforms.joined(separator: ", "))")
                                            .padding(.leading, 10)
                                            .font(.system(size: isCompact ? 20 : 34))
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                    
                                    Group {
                                        Text(loginStatusMessage)
                                            .multilineTextAlignment(.center)
                                        Button {
                                            upload()
                                            if loginStatusMessage != "" {
                                                isAddingGame = false
                                            }
                                        } label: {
                                            Text("Add")
                                                .fontWeight(.medium)
                                                .font(.system(size: isCompact ? 20 : 34))
                                                .frame(width: isCompact ? 80 : 120, height: isCompact ? 50 : 80, alignment: .center)
                                                .background(CustomColor.secondaryColor)
                                                .foregroundColor(CustomColor.lightDarkColor)
                                                .cornerRadius(isCompact ? 10 : 20)
                                                .shadow(color: .black, radius: isCompact ? 2 : 4)
                                                .padding(isCompact ? 15 : 25)
                                        }
                                    }
                                }
                                .padding(isCompact ? 20 : 30)
                                .frame(width: isCompact ? 350 : 600, height: isCompact  ? 725 : 1050)
                                .background(CustomColor.lightDarkColor)
                                .cornerRadius(isCompact ? 15 : 30)
                                .overlay (
                                    // MARK: - DISMISS ADD GAME POPUP
                                    Button(action: {
                                        isAddingGame = false
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .font(isCompact ? .title : .largeTitle)
                                    }
                                        .foregroundColor(CustomColor.secondaryColor)
                                        .padding([.top, .leading], isCompact ? 20 : 30), alignment: .topLeading
                                )
                            }
                        }
                    }
                }
                .navigationViewStyle(StackNavigationViewStyle())
                .environment(\.colorScheme, isDark ? .dark : .light)
            }
        }
        .onAppear {
//            show()
            cartViewModel.getUserCartData(uid: UID)
        }
        .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
            ImagePicker(image: $image)
        }
    }
}

// MARK: - PREVIEWS
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(UID: .constant("zhW4xMPXYya8nGiUSDNJ5AR1yiu2"))
    }
}
