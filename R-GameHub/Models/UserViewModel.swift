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

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class UserViewModel: ObservableObject {
    
    // MARK: - PROPERTIES
    @Published var currentUser: User?
    @Published var user = [User]()
    private var db = Firestore.firestore()
    
    init() {
        getUserData()
    }
    
    // MARK: - FUNCTIONS
    
    // MARK: - GET ALL USERS
    func getUserData() {
        db.collection("user").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            self.user = documents.map { (queryDocumentSnapshot) -> User in
                let data = queryDocumentSnapshot.data()
                let name = data["name"] as? String ?? ""
                let email = data["email"] as? String ?? ""
                let phone = data["phone"] as? String ?? ""
                let money = data["money"] as? Double ?? 0
                let imageURL = data["imageURL"] as? String ?? ""
                let id = data["id"] as? String ?? ""
                 
                return User(id: id, name: name, email: email, phone: phone, money: money, imageURL: imageURL, documentID: queryDocumentSnapshot.documentID)
            }
        }
    }
    
    // MARK: - UPDATE USER NAME
    func updateUserName(UID: String, name: String) {
        db.collection("user").whereField("id", isEqualTo: UID).getDocuments { (result, error) in
            if error == nil {
                for document in result!.documents {
                    self.db.collection("user").document(document.documentID).updateData(["name" : name])
                }
            }
        }
    }
    
    // MARK: - UPDATE USER IMAGE
    func updateUserImage(UID: String, imageURL: String) {
        db.collection("user").whereField("id", isEqualTo: UID).getDocuments { (result, error) in
            if error == nil {
                for document in result!.documents {
                    self.db.collection("user").document(document.documentID).updateData(["imageURL": imageURL])
                }
            }
        }
    }
    
    // MARK: - ADD NEW USER
    func addNewUserData(id: String, name: String, email: String, phone: String, money: Double, imageURL: String) {
        db.collection("user").addDocument(data: ["id": id, "name": name, "email": email, "phone": phone, "money": money, "imageURL": imageURL])
    }
    
    // MARK: - UPDATE USER MONEY
    func updateMoney(UID: String, money: Double) {
        db.collection("user").whereField("id", isEqualTo: UID).getDocuments { (result, error) in
            if error == nil {
                for document in result!.documents {
                    self.db.collection("user").document(document.documentID).updateData(["money": money])
                }
            }
        }
    }
}
