//
//  ProfileView.swift
//  Cafe
//
//  Created by Toan Tran Chi on 13/09/2023.
//

import SwiftUI

struct ProfileView: View {
    @Binding var UID: String
//    @StateObject var userViewModel = UserViewModel()
    @State var name = ""
    @State var email = ""
    @EnvironmentObject var userViewModel: UserViewModel
    
//    func show() {
//        self.userViewModel.getUserData(UID: UID)
//    }
    var body: some View {
        
        VStack {
            Text("WELCOME!!")
//                .onAppear() {
//                    show()
//                }
            ForEach(userViewModel.user, id: \.uid) {user in
                Text(user.name)
                Text(user.email)
                Text(user.phone)
                Text(user.imageURL)
            }
            HStack {
                TextField("Name: ", text: $name)
                Button {
                    userViewModel.updateUserName(UID: UID, name: name)
                } label: {
                    Text("Change")
                }
            }
            HStack {
                TextField("Email: ", text: $email)
                Button {
                    userViewModel.updateUserEmail(UID: UID, email: email)
                } label: {
                    Text("Change")
                }
            }
//            TextField("Image: ", text: $name)
        }
        .frame(width: 300)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(UID: .constant("zhW4xMPXYya8nGiUSDNJ5AR1yiu2"))
    }
}
