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

struct ProfileView: View {
    @Binding var UID: String
    @StateObject var userViewModel = UserViewModel()
    @State var name = ""
    @State var email = ""
    
    func show() {
        self.userViewModel.getUserData()
    }
    var body: some View {
        
        VStack {
            Text("WELCOME!!")
                .onAppear() {
                    show()
                }
            ForEach(userViewModel.user, id: \.uid) {user in
                if (user.documentID == UID) {
                    Text(user.name)
                    Text(user.email)
                    Text(user.phone)
                    Text(user.imageURL)
                }
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
//                    userViewModel.updateUserEmail(UID: UID, email: email)
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
