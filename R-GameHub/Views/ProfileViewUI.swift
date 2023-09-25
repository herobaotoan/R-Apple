//
//  ProfileViewUI.swift
//  R-GameHub
//
//  Created by Nguyễn Tuấn Thắng on 23/09/2023.
//

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
    
    func show() {
        self.userViewModel.getUserData(UID: UID)
    }
    var body: some View {
        if isHomeView {
            HomeView(UID: $UID)
        } else if loggingOut {
            LogInView()
        } else {
            ZStack {
                let _ =  DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                    show()
                }
                CustomColor.primaryColor
                    .edgesIgnoringSafeArea(.all)
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
                        Image("ava")    // adding data from databaase
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(Circle())
                            .frame(width: isCompact ? 150 : 200)
                        
                        Text("User Name")   // adding data from databaase
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
                            Text("$9.99")    // Adding from database
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
                        
                        VStack{
                            
                        }
                    }
                    .padding(isCompact ? 20 : 30)
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
