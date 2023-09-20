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
     init() {
         getAllCartData()
     }
     func getAllCartData() {
         db.collection("cart").addSnapshotListener { (querySnapshot, error) in
             guard let documents = querySnapshot?.documents else {
                 print("No documents")
                 return
             }
             self.carts = documents.map { (queryDocumentSnapshot) -> Cart in
                 let data = queryDocumentSnapshot.data()
                 let uid = data["uid"] as? String ?? ""
                 let gameID = data["gameID"] as? [String] ?? [""]
                 return Cart(uid: uid, gameID: gameID, documentID: queryDocumentSnapshot.documentID)
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
