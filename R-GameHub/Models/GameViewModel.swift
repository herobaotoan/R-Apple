//
//  GameViewModel.swift
//  R-GameHub
//
//  Created by Toan Tran Chi on 19/09/2023.
//

import Foundation
import Firebase

class GameViewModel: ObservableObject {
    @Published var games = [Game]()
    private var db = Firestore.firestore()
    init() {
        getAllGameData()
    }
    func getAllGameData() {
        db.collection("game").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            self.games = documents.map { (queryDocumentSnapshot) -> Game in
                let data = queryDocumentSnapshot.data()
                let name = data["name"] as? String ?? ""
                let description = data["description"] as? String ?? ""
                let price = data["price"] as? Double ?? 0
                let platform = data["platform"] as? [String] ?? [""]
                let genre = data["genre"] as? [String] ?? [""]
                let developer = data["developer"] as? String ?? ""
                let rating = data["rating"] as? [Int] ?? [0]
                let imageURL = data["imageURL"] as? String ?? ""
                let userID = data["userID"] as? String ?? ""
                return Game(name: name, description: description, price: price, platform: platform, genre: genre, developer: developer, rating: rating, imageURL: imageURL, userID: userID, documentID: queryDocumentSnapshot.documentID)
            }
        }
    }
//     func addNewGameData(name: String, platform: [String], genre: [String], developer: String, rating: [Int], imageURL: String, userID: String) {
    func addNewGameData(newGame: Game) {
       do {
           let _ = try db.collection("game").addDocument(from: newGame)
       }
       catch {
           print(error)
       }
    }
    func updateGameRatinglist(documentID: String, ratingList: [Int]) {
        db.collection("game").document(documentID).updateData(["rating" : ratingList])
    }
   
    func removeGameData(documentID: String) {
        db.collection("game").document(documentID).delete { (error) in
            if let error = error {
                print("Error removing document: \(error)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
}
