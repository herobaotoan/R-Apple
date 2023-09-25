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

struct CartItemView: View {
    // MARK: - DECLARE VARIABLES
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    var isCompact: Bool {horizontalSizeClass == .compact}
    
    @AppStorage("isDarkMode") private var isDark = false
    
    @State var game: Game
    @State var UID: String
    
    // MARK: - GAME CARD VIEW IN CART
    var body: some View {
        ZStack {
            HStack(alignment: .top) {
                AsyncImage(url: URL(string: game.imageURL)) {image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Image("game-product")
                }
                .frame(width: isCompact ? 100 : 175, height: isCompact ? 100 : 175)
                .clipShape(RoundedRectangle(cornerRadius: isCompact ? 15 : 25))
                .padding(.trailing, isCompact ? 15 : 30)
                VStack {
                    Text("\(game.name)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(size: isCompact ? 20 : 34))
                        .fontWeight(.medium)
                        .padding(.bottom, isCompact ? 10 : 20)
                    Text("$\(game.price, specifier: "%.2f")")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .italic()
                        .font(.system(size: isCompact ? 16 : 26))
                }
                .multilineTextAlignment(.leading)
            }
        }
    }
}

// MARK: - PREVIEWS
struct CartItemView_Previews: PreviewProvider {
    static var previews: some View {
        CartItemView(game: Game(name: "Elden Rioweuhfosnfosnco eoclewojfboewcboweicnbng", description: "", price: 0 ,platform: ["PS4", "Xbox"], genre: ["Action", "RPG", "OpenWorld", "Soul-like"], developer: "FromSoftware", rating: [5,4,5,5,4,5], imageURL: "https://firebasestorage.googleapis.com/v0/b/ios-app-4da46.appspot.com/o/eldenring.jpg?alt=media&token=25132cbc-e9e2-432f-b072-5c04cf92183d", userID: "123456"), UID: "zhW4xMPXYya8nGiUSDNJ5AR1yiu2")
    }
}
