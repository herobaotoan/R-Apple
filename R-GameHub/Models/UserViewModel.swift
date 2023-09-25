//
//  UserViewModel.swift
//  Cafe
//
//  Created by Toan Tran Chi on 13/09/2023.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class UserViewModel: ObservableObject {
//    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var user = [User]()
    
    private var db = Firestore.firestore()
//
    
    init() {
        getUserData()
    }
    
//    init(){
//        self.userSession = Auth.auth().currentUser
//        
//        Task {
//            await fetchUserData()
//        }
//    }
    
//    func fetchUserData() async {
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//        
//        guard let snapshot = try? await db.collection("users").document(uid).getDocument() else { return }
//        self.currentUser = try? snapshot.data(as: User.self)
//    }
//    
//    func signIn(withEmail email: String, password: String ) async throws {
//        do {
//            let result = try await Auth.auth().signIn(withEmail: email, password: password)
//            self.userSession = result.user
//            await fetchUserData()
//        } catch {
//            
//        }
//    }
    
    func getUserData() {
        db.collection("user").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            self.user = documents.map { (queryDocumentSnapshot) -> User in
                let data = queryDocumentSnapshot.data()
                let name = data["name"] as? String ?? ""
                let rating = data["rating"] as? Int ?? 0
                let email = data["email"] as? String ?? ""
                let phone = data["phone"] as? String ?? ""
                let imageURL = data["imageURL"] as? String ?? ""
                let id = data["id"] as? String ?? ""
                 
                 return User(id: id, name: name, email: email, phone: phone, imageURL: imageURL, documentID: queryDocumentSnapshot.documentID)
            }
        }
    }
    
//    func getUserData(UID: String) {
//        db.collection("user").addSnapshotListener { (querySnapshot, error) in
//            guard let documents = querySnapshot?.documents else {
//                print("No documents")
//                return
//            }
//            self.user = documents.map { (queryDocumentSnapshot) -> User in
////                if queryDocumentSnapshot.documentID == UID {
//                var name = ""
//                var email = ""
//                var phone = ""
//                var imageURL = ""
//                var id = ""
//                let data = queryDocumentSnapshot.data()
//                if data["id"] as? String ?? "" == UID
//                {
//                    id = data["id"] as? String ?? ""
//                    name = data["name"] as? String ?? ""
//                    email = data["email"] as? String ?? ""
//                    phone = data["phone"] as? String ?? ""
//                    imageURL = data["imageURL"] as? String ?? ""
//                }
//                return User(id: id, name: name, email: email, phone: phone, imageURL: imageURL, documentID: queryDocumentSnapshot.documentID)
//            }
//        }
//    }
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
