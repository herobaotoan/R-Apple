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
    
    @Binding var UID: String
    @StateObject var userViewModel = UserViewModel()
    @State var name = ""
    @State var email = ""
    
    func show() {
        self.userViewModel.getUserData(UID: UID)
    }
    var body: some View {
        ZStack {
            let _ =  DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                show()
            }
            CustomColor.primaryColor
                .edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    Button {
                        
                    } label: {
                        Image(systemName: "house.circle.fill")
                            .font(isCompact ? .title : .largeTitle)
                            .foregroundColor(CustomColor.secondaryColor)
                    }
                    
                    Spacer()
                    
                    // setting for the user
                    Menu {
                        
                        Button {
                            
                        } label: {
                            Text("Edit profile")
                        }
                        
                        Button{
                            
                        } label: {
                            Text("Change password")
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
                        .frame(width: 170)
                        .padding()
                    
                    Text("User Name")   // adding data from databaase
                        .font(.system(size: 26))
                        .foregroundColor(CustomColor.darkLightColor)
                    
                    HStack{
                        VStack{
                            HStack{
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                Text("Current Ledge")
                                    .foregroundColor(CustomColor.darkLightColor)
                            }
                            Text("Gold")    // Adding from database
                                .font(.system(size: 24))
                                .bold()
                        }
                        .padding()
                        .frame(width: 180)
                        .border(CustomColor.secondaryColor)
                        .cornerRadius(3)
                        
                        VStack{
                            HStack{
                                Image(systemName: "dollarsign.circle.fill")
                                    .foregroundColor(.yellow)
                                Text("Total coins")
                                    .foregroundColor(CustomColor.darkLightColor)
                            }
                            Text("1.6 $")    // Adding from database
                                .font(.system(size: 24))
                                .bold()
                        }
                        .padding()
                        .frame(width: 180)
                        .border(CustomColor.secondaryColor)
                        .cornerRadius(3)
                        
                    }.padding()
                    
                    HStack{
                        Text("Bought")
                            .bold()
                            .font(.system(size: 28))
                            .offset(y:15)
                        Spacer()
                    }.padding(.horizontal)
                    
                    Divider()
                        .background(CustomColor.secondaryColor)
                        .padding(.horizontal)
                    
                    VStack{
                        
                    }.padding()
                    
                } // Scrollview
            }
        }   // ZStack
    }
}

struct ProfileViewUI_Previews: PreviewProvider {
    static var previews: some View {
        ProfileViewUI(UID: .constant("zhW4xMPXYya8nGiUSDNJ5AR1yiu2"))
    }
}
