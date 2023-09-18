//
//  SignUpView.swift
//  DisplayGame
//
//  Created by Nguyễn Tuấn Thắng on 13/09/2023.
//

import SwiftUI

struct SignUpView: View {
    
    @State var emailAddress = ""
    @State var phoneNumber: Int = 0
    @State var username = ""
    @State private var password = ""
    
    @State var isHiddenText: Bool = true
    @State var isLogin: Bool = false
    @State var isRegistered: Bool = false
    
    var body: some View {
        ZStack{
            if isLogin {
                LogInView()
            } else {
                ZStack{
                    CustomColor.primaryColor
                        .edgesIgnoringSafeArea(.all)
                    VStack {
                        Image("app-logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 150, height: 150)
                        
                        VStack(spacing: 30) {
                            HStack{
                                Button {
                                    isLogin = true
                                } label: {
                                    VStack{
                                        Text("Log in")
                                            .font(.system(size: 24))
                                            .frame(width: 150)
                                            .foregroundColor(CustomColor.primaryColor)
                                    }
                                }
                                
                                Button{
                                    // Nothing, because the page is signup page
                                } label: {
                                    VStack{
                                        Text("Sign up")
                                            .font(.system(size: 24))
                                            .frame(width: 150)
                                            .foregroundColor(CustomColor.secondaryColor)
                                        Rectangle()
                                            .frame(width: 150,height: 2)
                                            .foregroundColor(CustomColor.secondaryColor)
                                    }
                                }
                            }
                            
                            HStack{
                                Image(systemName: "envelope.fill")
                                    .padding(10)
                                    .foregroundColor(CustomColor.secondaryColor)
                                VStack{
                                    TextField("Email", text: self.$emailAddress)
                                        .font(.system(size: 20))
                                    Divider()
                                        .background(CustomColor.secondaryColor)
                                }
                            }
                            
                            HStack{
                                Image(systemName: "phone.fill")
                                    .padding(10)
                                    .foregroundColor(CustomColor.secondaryColor)
                                VStack{
                                    TextField("Phone Number", text: Binding(
                                        get: { "\(phoneNumber)" },
                                        set: {
                                            if let newValue = Int($0) {
                                                phoneNumber = newValue
                                            }
                                        }
                                    ))
                                    Divider()
                                        .background(CustomColor.secondaryColor)
                                }
                            }
                            
                            // Username
                            HStack{
                                Image(systemName: "person.fill")
                                    .padding(10)
                                    .foregroundColor(CustomColor.secondaryColor)
                                VStack{
                                    TextField("username", text: self.$username)
                                        .font(.system(size: 20))
                                    Divider()
                                        .background(CustomColor.secondaryColor)
                                }
                            }
                            
                            // Password
                            HStack {
                                Image(systemName: "lock.fill")
                                    .padding(10)
                                    .foregroundColor(CustomColor.secondaryColor)
                                VStack {
                                    if isHiddenText {
                                        SecureField("password", text: self.$password) // hidden text
                                            .font(.system(size: 20))
                                    } else {
                                        TextField("password", text: self.$password) // shown text
                                            .font(.system(size: 20))
                                    }
                                    Divider()
                                        .background(CustomColor.secondaryColor)
                                }
                            }.overlay(
                                // show or hide the password
                                HStack{
                                    Spacer()
                                    Button{
                                        isHiddenText.toggle()
                                    }label: {
                                        Image(systemName: isHiddenText ? "eye.slash.fill":"eye.fill").foregroundColor(CustomColor.secondaryColor)
                                        
                                    }
                                }
                            )
                            
                            // Registering button
                            Button{
                                // Logic for information before registering
                                
                                isRegistered = true
                            } label: {
                                Text("Register")
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
                        .frame(width: 350, height: 480)
                        .background()
                        .cornerRadius(20)
                        .shadow(color: CustomColor.shadowColor, radius: 10)
                        
                        //                Text("Forgotten the password")
                    }   // VStack
                    
                    if isRegistered {
                        ZStack{
                            CustomColor.shadowColor
                            VStack{
                                Text("The account is created successfully!")
                                    .padding()
                                
                                Button{
                                    isLogin = true
                                }label: {
                                    Text("Back")
                                        .font(.system(size: 20))
                                        .frame(width: 80, height: 50, alignment: .center)
                                        .background(CustomColor.secondaryColor)
                                        .foregroundColor(CustomColor.lightDarkColor)
                                        .cornerRadius(10)
                                        .shadow(color: .black, radius: 2)
                                        .padding()
                                }
                            }
                            .frame(width: 350, height: 200)
                            .background()
                            .cornerRadius(15)
                        }
                    }
                    
                }   // ZStack
            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(phoneNumber: 0245246565)
    }
}
