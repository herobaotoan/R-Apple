//
//  ContentView.swift
//  DisplayGame
//
//  Created by Nguyễn Tuấn Thắng on 13/09/2023.
//

import SwiftUI

struct LogInView: View {
    
    @State var username = ""
    @State private var password = ""
    
    @State var isHiddenText: Bool = true
    @State var signing: Bool = false
    @State var logging: Bool = false
    
    var body: some View {
        ZStack{
            if logging{
                HomeView()
            } else {
                ZStack{
                    Color("BackgroundColor")
                        .edgesIgnoringSafeArea(.all)
                    VStack {
                        Image("app-logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200, height: 200)
                            .foregroundColor(.accentColor)
                        VStack(spacing: 30){
                            
                            HStack{
                                Button{
                                    
                                } label: {
                                    VStack{
                                        Text("Log in")
                                            .font(.system(size: 24))
                                            .frame(width: 150)
                                            .foregroundColor(Color("DarkOrLight"))
                                        Rectangle()
                                            .frame(width: 150,height: 2)
                                    }
                                }
                                
                                Button{
                                    signing = true
                                } label: {
                                    Text("Sign up")
                                        .font(.system(size: 24))
                                        .frame(width: 150)
                                }
                            }
                            
                            // Username
                            HStack{
                                Image(systemName: "person.fill")
                                    .padding(10)
                                VStack{
                                    TextField("username", text: self.$username)
                                        .font(.system(size: 20))
                                    Divider()
                                        .background(Color("DarkOrLight"))
                                }
                            }
                            
                            // Password
                            HStack{
                                Image(systemName: "lock.fill")
                                    .padding(10)
                                VStack{
                                    if isHiddenText{
                                        SecureField("password", text: self.$password) // hidden text
                                            .font(.system(size: 20))
                                    } else {
                                        TextField("password", text: self.$password) // shown text
                                            .font(.system(size: 20))
                                    }
                                    Divider()
                                        .background(Color("DarkOrLight"))
                                }
                            }
                            .overlay(
                                // show or hide the password
                                HStack{
                                    Spacer()
                                    Button{
                                        isHiddenText.toggle()
                                    }label: {
                                        Image(systemName: isHiddenText ? "eye.slash.fill":"eye.fill").foregroundColor(Color("DarkOrLight"))
                                        
                                    }
                                }
                            )
                            
                            Button{
                                // Logic for logging into the home page
                                
                                logging = true
                            } label: {
                                Text("Log in")
                                    .font(.system(size: 28))
                                    .frame(width: 120, height: 60, alignment: .center)
                                    .background(.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .shadow(color: .black, radius: 2)
                                    .padding()
                                
                            }
                            
                        } // VStack of logging
                        .padding()
                        .frame(width: 350, height: 340)
                        .background()
                        .cornerRadius(20)
                        .shadow(color: Color("shadowColor"), radius: 10)
                        
                        //                Text("Forgotten the password")
                    }   // VStack
                }   // ZStack
            }; if signing{
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