//
//  GameViewModel.swift
//  R-GameHub
//
//  Created by Toan Tran Chi on 19/09/2023.
//

import Foundation
import Firebase

 class ReviewViewModel: ObservableObject {
     @Published var reviews = [Review]()
     private var db = Firestore.firestore()
     init() {
         getAllCartData()
     }
     func getAllCartData() {
         db.collection("review").addSnapshotListener { (querySnapshot, error) in
             guard let documents = querySnapshot?.documents else {
                 print("No documents")
                 return
             }
             self.reviews = documents.map { (queryDocumentSnapshot) -> Review in
                 let data = queryDocumentSnapshot.data()
                 let description = data["description"] as? String ?? ""
                   let rating = data["rating"] as? Int ?? 0
                     let userID = data["userID"] as? String ?? ""
                     let gameID = data["gameID"] as? String ?? ""
                  
                  return Review(description: description, rating: rating, userID: userID, gameID: gameID, documentID: queryDocumentSnapshot.documentID)
             }
         }
     }
     
     //DO cartViewModel.getUserCartData(uid: //put uid in here)
//     func getGameReviewData(uid: String) {
//         db.collection("review").whereField("gameID", isEqualTo: uid).getDocuments { (result, error) in
//             if error == nil {
//                 for document in result!.documents {
//                     self.db.collection("review").addSnapshotListener { (querySnapshot, error) in
//                         guard let documents = querySnapshot?.documents else {
//                             print("No documents")
//                             return
//                         }
//                         self.reviews = documents.map { (queryDocumentSnapshot) -> Review in
//                             var description = ""
//                             var rating = 0
//                             var userID = ""
//                             var gameID = ""
//                             if queryDocumentSnapshot.documentID == document.documentID {
//                                 let data = queryDocumentSnapshot.data()
//                                 description = data["description"] as? String ?? ""
//                                 rating = data["rating"] as? Int ?? 0
//                                 userID = data["userID"] as? String ?? ""
//                                 gameID = data["gameID"] as? String ?? ""
//                             }
//                             return Review(description: description, rating: rating, userID: userID, gameID: gameID, documentID: document.documentID)
//                         }
//                     }
//                 }
//             }
//         }
//     }
     
     func addNewReviewData(newReview: Review) {
        do {
            let _ = try db.collection("review").addDocument(from: newReview)
        }
        catch {
            print(error)
        }
     }
     
//     func updateGamelist(documentID: String, gamelist: [String]) {
//         db.collection("cart").document(documentID).updateData(["gameID" : gamelist])
//     }
//
//     func addToCart(uid: String, gamelist: [String]) {
//         db.collection("cart").whereField("uid", isEqualTo: uid).getDocuments { (result, error) in
//             if error == nil {
//                 for document in result!.documents {
//                     self.db.collection("cart").document(document.documentID).updateData(["gameID" : gamelist])
//                 }
//             }
//         }
//     }
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
