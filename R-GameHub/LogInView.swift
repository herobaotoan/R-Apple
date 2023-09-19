//
//  ContentView.swift
//  DisplayGame
//
//  Created by Nguyễn Tuấn Thắng on 13/09/2023.
//

import SwiftUI

struct LogInView: View {
    
    @State var email = ""
    @State private var password = ""
    
    @State var isHiddenText: Bool = true
    @State var signing: Bool = false
    @State var logging: Bool = false
    @AppStorage("isDarkMode") private var isDark = false
    
    var body: some View {
        ZStack {
            if logging {
                HomeView()
            } else {
                ZStack {
                    CustomColor.primaryColor
                        .edgesIgnoringSafeArea(.all)
                    VStack {
                        Image("app-logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 150, height: 150)
                            .padding(.bottom, 10)
                        VStack(spacing: 30) {
                            HStack {
                                Button {
                                    
                                } label: {
                                    VStack{
                                        Text("Log in")
                                            .font(.system(size: 24))
                                            .frame(width: 150)
                                            .foregroundColor(CustomColor.secondaryColor)
                                        Rectangle()
                                            .frame(width: 150,height: 2)
                                            .foregroundColor(CustomColor.secondaryColor)
                                    }
                                }
                                
                                Button {
                                    signing = true
                                } label: {
                                    Text("Sign up")
                                        .font(.system(size: 24))
                                        .frame(width: 150)
                                        .foregroundColor(CustomColor.primaryColor)
                                }
                            }
                            
                            // Username
                            HStack {
                                Image(systemName: "envelope.fill")
                                    .padding(10)
                                    .foregroundColor(CustomColor.secondaryColor)
                                VStack {
                                    TextField("Email", text: self.$email)
                                        .font(.system(size: 20))
                                    Divider()
                                        .background(CustomColor.secondaryColor)
                                }
                            }
                            
                            // Password
                            HStack{
                                Image(systemName: "lock.fill")
                                    .padding(10)
                                    .foregroundColor(CustomColor.secondaryColor)
                                VStack{
                                    if isHiddenText {
                                        SecureField("Password", text: self.$password) // hidden text
                                            .font(.system(size: 20))
                                    } else {
                                        TextField("Password", text: self.$password) // shown text
                                            .font(.system(size: 20))
                                    }
                                    Divider()
                                        .background(CustomColor.secondaryColor)
                                }
                            }
                            .overlay(
                                // show or hide the password
                                HStack {
                                    Spacer()
                                    Button {
                                        isHiddenText.toggle()
                                    } label: {
                                        Image(systemName: isHiddenText ? "eye.slash.fill" : "eye.fill").foregroundColor(CustomColor.secondaryColor)
                                        
                                    }
                                }
                            )
                            
                            Button {
                                // Logic for logging into the home page
                                logging = true
                            } label: {
                                Text("Log in")
                                    .font(.system(size: 28))
                                    .frame(width: 120, height: 60, alignment: .center)
                                    .background(CustomColor.secondaryColor)
                                    .foregroundColor(CustomColor.lightDarkColor)
                                    .cornerRadius(10)
                                    .shadow(color: .black, radius: 2)
                                    .padding()
                            }
                        } // VStack of logging
                        .padding()
                        .frame(width: 350, height: 340)
                        .background(CustomColor.lightDarkColor)
                        .cornerRadius(20)
                        .shadow(color: CustomColor.shadowColor, radius: 10)
                        
                        //                Text("Forgotten the password")
                    }   // VStack
                }   // ZStack
                .environment(\.colorScheme, isDark ? .dark : .light)

            }
            if signing {
                SignUpView()
            }
        }
    }
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}
