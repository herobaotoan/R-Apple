//
//  UserViewModel.swift
//  Cafe
//
//  Created by Toan Tran Chi on 13/09/2023.
//

import Foundation
import FirebaseFirestore

class UserViewModel: ObservableObject {
    @Published var user = [User]()
//    var UID: String
    private var db = Firestore.firestore()
//    init() {
//        getAllOrderData(UID: "")
//    }
//    init(UID: String) {
//        self.UID = UID
//        getUserData(UID: self.UID)
//    }
    func getUserData(UID: String) {
        db.collection("user").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            self.user = documents.map { (queryDocumentSnapshot) -> User in
//                if queryDocumentSnapshot.documentID == UID {
                var name = ""
                var email = ""
                var phone = ""
                var imageURL = ""
                var id = ""
                let data = queryDocumentSnapshot.data()
                if data["id"] as? String ?? "" == UID
                {
                    id = data["id"] as? String ?? ""
                    name = data["name"] as? String ?? ""
                    email = data["email"] as? String ?? ""
                    phone = data["phone"] as? String ?? ""
                    imageURL = data["imageURL"] as? String ?? ""
                }
                return User(id: id, name: name, email: email, phone: phone, imageURL: imageURL, documentID: queryDocumentSnapshot.documentID)
            }
        }
    }
    func updateUserName(UID: String, name: String) {
        db.collection("user").document(UID).updateData(["name" : name])
    }
    func updateUserEmail(UID: String, email: String) {
        db.collection("user").document(UID).updateData(["email" : email])
    }
    
    func addNewUserData(id: String, name: String, email: String, phone: String, imageURL: String) {
        db.collection("user").addDocument(data: ["id": id, "name": name, "email": email, "phone": phone, "imageURL": imageURL])
    }
    
    func removeOrderData(documentID: String) {
        db.collection("order").document(documentID).delete { (error) in
            if let error = error {
                print("Error removing document: \(error)")
            } else {
                print("Document successfully removed!")
            }
        }
    }

}
