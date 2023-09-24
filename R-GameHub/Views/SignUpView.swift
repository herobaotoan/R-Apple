//
//  SignUpView.swift
//  DisplayGame
//
//  Created by Nguyễn Tuấn Thắng on 13/09/2023.
//

import SwiftUI
import Firebase

struct SignUpView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    var isCompact: Bool {horizontalSizeClass == .compact}
    
    @AppStorage("isDarkMode") private var isDark = false
    
    @State var emailAddress = ""
    @State var phoneNumber: Int = 0
    @State var username = ""
    @State var UID = ""
    @State private var password = ""
    
    @State var errorMessage = ""
    
    @StateObject private var userViewModel = UserViewModel()
    @StateObject private var cartViewModel = CartViewModel()
    
    @State var isHiddenText: Bool = true
    @State var isLogin: Bool = false
    @State var isRegistered: Bool = false
    
    func signUp() {
        Auth.auth().createUser(withEmail: emailAddress, password: password) { authResult, error in
            if error != nil {
                errorMessage = error?.localizedDescription ?? ""
                isRegistered = false
            } else {
                print("success")
                isRegistered = true
                login()
            }
        }
    }
    
    
    func login() {
        Auth.auth().signIn(withEmail: emailAddress, password: password) { (result, error) in
            if error != nil {
                errorMessage = error?.localizedDescription ?? ""
            } else {
                errorMessage = "Login success"
                UID = Auth.auth().currentUser!.uid
                
                //Add to collection
                userViewModel.addNewUserData(id: UID, name: username, email: emailAddress, phone: String(phoneNumber), imageURL: "")
                cartViewModel.addNewCartData(newCart: Cart(uid: UID, gameID: [""]))
            }
        }
    }
    
    var body: some View {
        ZStack{
            if isLogin {
                LogInView()
//                ProfileView(UID: $UID)
            } else {
                ZStack{
                    CustomColor.primaryColor
                        .edgesIgnoringSafeArea(.all)
                    VStack {
                        Image("app-logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: isCompact ? 150 : 250, height: isCompact ? 150 : 250)
                            .padding(.bottom, isCompact ? 10 : 20)
                        VStack(spacing: isCompact ? 30 : 50) {
                            HStack {
                                Button {
                                    isLogin = true
                                } label: {
                                    VStack{
                                        Text("Log in")
                                            .font(.system(size: isCompact ? 24 : 40))
                                            .frame(width: isCompact ? 150 : 250)
                                            .foregroundColor(CustomColor.primaryColor)
                                    }
                                }
                                
                                Button{
                                    // Nothing, because the page is signup page
                                } label: {
                                    VStack {
                                        Text("Sign up")
                                            .font(.system(size: isCompact ? 24 : 40))
                                            .fontWeight(.medium)
                                            .frame(width: isCompact ? 150 : 250)
                                            .foregroundColor(CustomColor.secondaryColor)
                                        Rectangle()
                                            .frame(width: isCompact ? 150 : 250, height: isCompact ? 2 : 4)
                                            .foregroundColor(CustomColor.secondaryColor)
                                    }
                                }
                            }
                            
                            HStack {
                                Image(systemName: "envelope.fill")
                                    .font(isCompact ? .title2 : .largeTitle)
                                    .padding(isCompact ? 10 : 20)
                                    .foregroundColor(CustomColor.secondaryColor)
                                VStack{
                                    TextField("Email", text: self.$emailAddress)
                                        .font(.system(size: isCompact ? 20 : 34))
                                    Divider()
                                        .background(CustomColor.secondaryColor)
                                }
                            }
                            
                            HStack{
                                Image(systemName: "phone.fill")
                                    .font(isCompact ? .title2 : .largeTitle)
                                    .padding(isCompact ? 10 : 20)
                                    .foregroundColor(CustomColor.secondaryColor)
                                VStack{
                                    TextField("Phone number", text: Binding(
                                        get: { "\(phoneNumber)" },
                                        set: {
                                            if let newValue = Int($0) {
                                                phoneNumber = newValue
                                            }
                                        }
                                    ))
                                    .font(.system(size: isCompact ? 20 : 34))
                                    Divider()
                                        .background(CustomColor.secondaryColor)
                                }
                            }
                            
                            // Username
                            HStack{
                                Image(systemName: "person.fill")
                                    .font(isCompact ? .title2 : .largeTitle)
                                    .padding(isCompact ? 10 : 20)
                                    .foregroundColor(CustomColor.secondaryColor)
                                VStack{
                                    TextField("Username", text: self.$username)
                                        .font(.system(size: isCompact ? 20 : 34))
                                    Divider()
                                        .background(CustomColor.secondaryColor)
                                }
                            }
                            
                            // Password
                            HStack {
                                Image(systemName: "lock.fill")
                                    .font(isCompact ? .title2 : .largeTitle)
                                    .padding(isCompact ? 10 : 20)
                                    .foregroundColor(CustomColor.secondaryColor)
                                VStack {
                                    if isHiddenText {
                                        SecureField("Password", text: self.$password) // hidden text
                                            .font(.system(size: isCompact ? 20 : 34))
                                    } else {
                                        TextField("Password", text: self.$password) // shown text
                                            .font(.system(size: isCompact ? 20 : 34))
                                    }
                                    Divider()
                                        .background(CustomColor.secondaryColor)
                                }
                            }
                            .overlay(
                                // show or hide the password
                                HStack{
                                    Spacer()
                                    Button{
                                        isHiddenText.toggle()
                                    } label: {
                                        Image(systemName: isHiddenText ? "eye.slash.fill" : "eye.fill")
                                            .foregroundColor(CustomColor.secondaryColor)
                                            .font(isCompact ? .title2 : .largeTitle)
                                            .padding([.trailing, .bottom], isCompact ? 5 : 10)
                                        
                                    }
                                }
                            )
                            
                            // Registering button
                            Button {
                                signUp()
                            } label: {
                                Text("Register")
                                    .font(.system(size: isCompact ? 28 : 50))
                                    .frame(width: isCompact ? 120 : 220, height: isCompact ? 60 : 100, alignment: .center)
                                    .background(CustomColor.secondaryColor)
                                    .foregroundColor(CustomColor.lightDarkColor)
                                    .cornerRadius(isCompact ? 10 : 20)
                                    .shadow(color: .black, radius: isCompact ? 2 : 4)
                                    .padding(isCompact ? 20 : 30)
                                
                            }
                            
                        }
                        .padding(isCompact ? 20 : 30)
                        .frame(width: isCompact ? 350 : 650, height: isCompact ? 480 : 850)
                        .background()
                        .cornerRadius(isCompact ? 20 : 30)
                        .shadow(color: CustomColor.shadowColor, radius: isCompact ? 10 : 20)
                        Text(errorMessage)
                    }
                    if isRegistered {
                        ZStack {
                            CustomColor.shadowColor
                                .edgesIgnoringSafeArea(.all)
                            VStack {
                                Text("The account is created successfully!")
                                    .font(.system(size: isCompact ? 18 : 32))
                                    .padding(isCompact ? 15 : 25)
                                
                                Button {
                                    isLogin = true
                                } label: {
                                    Text("Back")
                                        .font(.system(size: isCompact ? 20 : 34))
                                        .frame(width: isCompact ? 80 : 120, height: isCompact ? 50 : 80, alignment: .center)
                                        .background(CustomColor.secondaryColor)
                                        .foregroundColor(CustomColor.lightDarkColor)
                                        .cornerRadius(isCompact ? 10 : 20)
                                        .shadow(color: .black, radius: isCompact ? 2 : 4)
                                        .padding(isCompact ? 15 : 25)
                                }
                            }
                            .frame(width: isCompact ? 350 : 650, height: isCompact  ? 180 : 300)
                            .background()
                            .cornerRadius(isCompact ? 15 : 30)
                        }
                    }
                }
                .environment(\.colorScheme, isDark ? .dark : .light)

            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(phoneNumber: 0245246565)
    }
}
