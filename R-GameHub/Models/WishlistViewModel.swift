//
//  WishlistViewModel.swift
//  R-GameHub
//
//  Created by Nguyen Thi Ha Giang on 25/09/2023.
//

import Foundation
import Firebase
import FirebaseFirestore

class WishlistViewModel: ObservableObject {
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
