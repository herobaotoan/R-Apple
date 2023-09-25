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

class WishlistViewModel: ObservableObject {
    
    // MARK: - PROPERTIES
    @Published var wishlists = [Wishlist]()
    private var db = Firestore.firestore()
    
    init(){
        getWishlist()
    }
    
    func getWishlist() {
        db.collection("favorite").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            self.wishlists = documents.map { (queryDocumentSnapshot) -> Wishlist in
                let data = queryDocumentSnapshot.data()
                let uid = data["uid"] as? String ?? ""
                let gameID = data["gameID"] as? [String] ?? [""]
                return Wishlist(uid: uid, gameID: gameID, documentID: queryDocumentSnapshot.documentID)
            }
        }
    }
    
    func getUserWishlist(uid: String) {
        db.collection("favorite").whereField("uid", isEqualTo: uid).getDocuments { (result, error) in
            if error == nil {
                for document in result!.documents {
                    self.db.collection("favorite").addSnapshotListener { (querySnapshot, error) in
                        guard let documents = querySnapshot?.documents else {
                            print("No documents")
                            return
                        }
                        self.wishlists = documents.map { (queryDocumentSnapshot) -> Wishlist in
                            var uid = ""
                            var gameID: [String] = [""]
                            if queryDocumentSnapshot.documentID == document.documentID {
                                let data = queryDocumentSnapshot.data()
                                uid = data["uid"] as? String ?? ""
                                gameID = data["gameID"] as? [String] ?? [""]
                            }
                            return Wishlist(uid: uid, gameID: gameID, documentID: queryDocumentSnapshot.documentID)
                        }
                    }
                }
            }
        }
    }

    func newWishlist(newWishlist: Wishlist) {
       do {
           let _ = try db.collection("favorite").addDocument(from: newWishlist)
       }
       catch {
           print(error)
       }
    }

    func updateWishlist(documentID: String, gamelist: [String]) {
        db.collection("favorite").document(documentID).updateData(["gameID" : gamelist])
    }

    func newFavorite(uid: String, gamelist: [String]) {
        db.collection("favorite").whereField("uid", isEqualTo: uid).getDocuments { (result, error) in
            if error == nil {
                for document in result!.documents {
                    self.db.collection("favorite").document(document.documentID).updateData(["gameID" : gamelist])
                }
            }
        }
    }
}
