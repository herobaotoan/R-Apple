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

 class CartViewModel: ObservableObject {
     
     // MARK: - PROPERTIES
     @Published var carts = [Cart]()
     private var db = Firestore.firestore()
     
     // MARK: - FUNCTIONS
     
     // MARK: - GET USER'S CART
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
     
     // MARK: - ADD NEW CART
     func addNewCartData(newCart: Cart) {
        do {
            let _ = try db.collection("cart").addDocument(from: newCart)
        }
        catch {
            print(error)
        }
     }
     
     // MARK: - UPDATE CART
     func updateGCart(documentID: String, gamelist: [String]) {
         db.collection("cart").document(documentID).updateData(["gameID" : gamelist])
     }
     
     // MARK: - ADD GAME TO CART
     func addToCart(uid: String, gamelist: [String]) {
         db.collection("cart").whereField("uid", isEqualTo: uid).getDocuments { (result, error) in
             if error == nil {
                 for document in result!.documents {
                     self.db.collection("cart").document(document.documentID).updateData(["gameID" : gamelist])
                 }
             }
         }
     }
 }
