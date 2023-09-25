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

struct ProfileViewUI: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    var isCompact: Bool {horizontalSizeClass == .compact}
    
    @AppStorage("isDarkMode") private var isDark = false
    @Binding var UID: String
    @StateObject var userViewModel = UserViewModel()
    @State var name = ""
    @State var email = ""
    @State var isHomeView: Bool = false
    @State var loggingOut: Bool = false
    
    var body: some View {
        if isHomeView {
            HomeView(UID: $UID)
        } else if loggingOut {
            LogInView()
        } else {
            ZStack {
                CustomColor.primaryColor
                    .edgesIgnoringSafeArea(.all)
                ForEach(userViewModel.user, id: \.uid) {user in
                    if user.id == UID {
                        VStack {
                            HStack {
                                Button {
                                    isHomeView = true
                                } label: {
                                    Image(systemName: "house.fill")
                                        .font(isCompact ? .title : .largeTitle)
                                        .foregroundColor(CustomColor.secondaryColor)
                                }
                                
                                Spacer()
                                
                                // setting for the user
                                Menu {
                                    Button {
                                        
                                    } label: {
                                        Label("Edit profile", systemImage: "person.fill")
                                    }
                                    
                                    Button(role: .destructive) {
                                        loggingOut = true
                                    } label: {
                                        Label("Log out", systemImage: "minus.circle")
                                    }
                                } label: {
                                    Image(systemName: "gearshape.fill")
                                        .font(isCompact ? .title : .largeTitle)
                                        .foregroundColor(CustomColor.secondaryColor)
                                }
                            }
                            .padding()
                            
                            ScrollView {
                                AsyncImage(url: URL(string: user.imageURL)) {image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                } placeholder: {
                                    Image("ava")
                                }
                                .frame(width: isCompact ? 150 : 200,  height: isCompact ? 150 : 200)
                                .clipShape(Circle())
                                .clipped()
                                
                                Text(user.name)
                                    .font(.system(size: isCompact ? 26 : 46))
                                    .fontWeight(.semibold)
                                    .foregroundColor(CustomColor.secondaryColor)
                                VStack {
                                    HStack {
                                        Image(systemName: "dollarsign.circle.fill")
                                            .foregroundColor(CustomColor.starColor)
                                            .font(.title)
                                        Text("Total coins")
                                            .font(.system(size: isCompact ? 22 : 36))
                                            .foregroundColor(CustomColor.secondaryColor)
                                    }
                                    Text("$\(user.money, specifier: "%.2f")")
                                        .font(.system(size: isCompact ? 24 : 40))
                                        .fontWeight(.medium)
                                        .foregroundColor(CustomColor.darkLightColor)
                                }
                                .padding(.bottom, isCompact ? 15 : 30)
                                
                                HStack {
                                    Text("Games Bought")
                                        .fontWeight(.medium)
                                        .font(.system(size: isCompact ? 26 : 46))
                                        .foregroundColor(CustomColor.secondaryColor)
                                    Spacer()
                                }
                                
                                Divider()
                                    .background(CustomColor.secondaryColor)
                                
                                VStack {
                                    
                                }
                            }
                            .padding(isCompact ? 20 : 30)
                        }
                    }
                }
            }
            .environment(\.colorScheme, isDark ? .dark : .light)
        }
    }
}

struct ProfileViewUI_Previews: PreviewProvider {
    static var previews: some View {
        ProfileViewUI(UID: .constant("zhW4xMPXYya8nGiUSDNJ5AR1yiu2"))
    }
}
