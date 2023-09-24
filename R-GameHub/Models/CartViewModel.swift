//
//  GameViewModel.swift
//  R-GameHub
//
//  Created by Toan Tran Chi on 19/09/2023.
//

import Foundation
import Firebase

 class CartViewModel: ObservableObject {
     @Published var carts = [Cart]()
     private var db = Firestore.firestore()
//     init() {
//         getAllCartData()
//     }
//     func getAllCartData() {
//         db.collection("cart").addSnapshotListener { (querySnapshot, error) in
//             guard let documents = querySnapshot?.documents else {
//                 print("No documents")
//                 return
//             }
//             self.carts = documents.map { (queryDocumentSnapshot) -> Cart in
//                 let data = queryDocumentSnapshot.data()
//                 let uid = data["uid"] as? String ?? ""
//                 let gameID = data["gameID"] as? [String] ?? [""]
//                 return Cart(uid: uid, gameID: gameID, documentID: queryDocumentSnapshot.documentID)
//             }
//         }
//     }
     
     //DO cartViewModel.getUserCartData(uid: //put uid in here)
     func getUserCartData(uid: String) {
         db.collection("cart").whereField("uid", isEqualTo: uid).getDocuments { (result, error) in
             if error == nil {
                 for document in result!.documents {
                     self.db.collection("cart").addSnapshotListener { (querySnapshot, error) in
                         guard let documents = querySnapshot?.documents else {
                             print("No documents")
                             return
                         }
                         self.carts = documents.map { (queryDocumentSnapshot) -> Cart in
                             var uid = ""
                             var gameID: [String] = [""]
                             if queryDocumentSnapshot.documentID == document.documentID {
                                 let data = queryDocumentSnapshot.data()
                                 uid = data["uid"] as? String ?? ""
                                 gameID = data["gameID"] as? [String] ?? [""]
                             }
                             return Cart(uid: uid, gameID: gameID, documentID: queryDocumentSnapshot.documentID)
                         }
                     }
                 }
             }
         }
     }
     
     func addNewCartData(newCart: Cart) {
        do {
            let _ = try db.collection("cart").addDocument(from: newCart)
        }
        catch {
            print(error)
        }
     }
     
     func updateGamelist(documentID: String, gamelist: [String]) {
         db.collection("cart").document(documentID).updateData(["gameID" : gamelist])
     }
     
     func addToCart(uid: String, gamelist: [String]) {
         db.collection("cart").whereField("uid", isEqualTo: uid).getDocuments { (result, error) in
             if error == nil {
                 for document in result!.documents {
                     self.db.collection("cart").document(document.documentID).updateData(["gameID" : gamelist])
                 }
             }
         }
     }
//     func removeGameData(documentID: String) {
//         db.collection("game").document(documentID).delete { (error) in
//             if let error = error {
//                 print("Error removing document: \(error)")
//             } else {
//                 print("Document successfully removed!")
//             }
//         }
//     }
 }
