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

struct LogInView: View {
    // MARK: - DECLARE VARIABLES
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    var isCompact: Bool {horizontalSizeClass == .compact}
    
    @AppStorage("isDarkMode") private var isDark = false
    
    @State var email = ""
    @State private var password = ""
    @State var UID = ""
    
    @State var errorMessage = ""
    
    @State var isHiddenText: Bool = true
    @State var signing: Bool = false
    @State var logging: Bool = false
    
    // MARK: - FUNCTION LOGIN
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                errorMessage = error?.localizedDescription ?? ""
                logging = false
            } else {
                errorMessage = "Login success"
                logging = true
                UID = Auth.auth().currentUser!.uid
            }
        }
    }
    
    var body: some View {
        ZStack {
            // MARK: - IF LOGIN SUCCESSFUL
            if logging {
                HomeView(UID: $UID)
//                ProfileView(UID: $UID)
//                TestHomeView()
//                CartView()
            } else {
                ZStack {
                    
                    // MARK: - LOGIN FORM VIEW
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
                                    
                                } label: {
                                    VStack{
                                        Text("Log in")
                                            .font(.system(size: isCompact ? 24 : 40))
                                            .fontWeight(.medium)
                                            .frame(width: isCompact ? 150 : 250)
                                            .foregroundColor(CustomColor.secondaryColor)
                                        Rectangle()
                                            .frame(width: isCompact ? 150 : 250, height: isCompact ? 2 : 4)
                                            .foregroundColor(CustomColor.secondaryColor)
                                    }
                                }
                                
                                
                                Button {
                                    signing = true
                                } label: {
                                    Text("Sign up")
                                        .font(.system(size: isCompact ? 24 : 40))
                                        .frame(width: isCompact ? 150 : 250)
                                        .foregroundColor(CustomColor.primaryColor)
                                }
                            }
                            .padding(.bottom, isCompact ? 0 : 10)
                            
                            // Username
                            HStack {
                                Image(systemName: "envelope.fill")
                                    .font(isCompact ? .title2 : .largeTitle)
                                    .padding(isCompact ? 10 : 20)
                                    .foregroundColor(CustomColor.secondaryColor)
                                VStack {
                                    TextField("Email", text: self.$email)
                                        .font(.system(size: isCompact ? 20 : 34))
                                    Divider()
                                        .background(CustomColor.secondaryColor)
                                }
                            }
                            
                            // Password
                            HStack{
                                Image(systemName: "lock.fill")
                                    .font(isCompact ? .title2 : .largeTitle)
                                    .padding(isCompact ? 10 : 20)
                                    .foregroundColor(CustomColor.secondaryColor)
                                VStack{
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
                                HStack {
                                    Spacer()
                                    Button {
                                        isHiddenText.toggle()
                                    } label: {
                                        Image(systemName: isHiddenText ? "eye.slash.fill" : "eye.fill")
                                            .foregroundColor(CustomColor.secondaryColor)
                                            .font(isCompact ? .title2 : .largeTitle)
                                            .padding([.trailing, .bottom], isCompact ? 5 : 10)
                                        
                                    }
                                }
                            )
                            .padding(.bottom, isCompact ? 0 : 10)
                            
                            Button {
                                // Logic for logging into the home page
                                login()
                            } label: {
                                Text("Log in")
                                    .fontWeight(.medium)
                                    .font(.system(size: isCompact ? 28 : 50))
                                    .frame(width: isCompact ? 120 : 180, height: isCompact ? 60 : 100, alignment: .center)
                                    .background(CustomColor.secondaryColor)
                                    .foregroundColor(CustomColor.lightDarkColor)
                                    .cornerRadius(isCompact ? 10 : 20)
                                    .shadow(color: .black, radius: isCompact ? 2 : 4)
                                    .padding(isCompact ? 20 : 30)
                            }
                        } // VStack of logging
                        .padding(isCompact ? 20 : 30)
                        .frame(width: isCompact ? 350 : 650, height: isCompact ? 350 : 600)
                        .background(CustomColor.lightDarkColor)
                        .cornerRadius(isCompact ? 20 : 30)
                        .shadow(color: CustomColor.shadowColor, radius: isCompact ? 10 : 20)
                        
                        //                Text("Forgotten the password")
                        Text(errorMessage)
                    }
                }
                .environment(\.colorScheme, isDark ? .dark : .light)

            }
            
            // MARK: - NAVIGATE TO SIGN UP VIEW
            if signing {
                SignUpView()
            }
        }
    }
}

// MARK: - PREVIEWS
struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}
