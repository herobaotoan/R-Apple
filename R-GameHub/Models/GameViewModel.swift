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

class GameViewModel: ObservableObject {
    
    // MARK: - PROPERTIES
    @Published var games = [Game]()
    private var db = Firestore.firestore()
    
    init() {
        getAllGameData()
    }
    
    // MARK: - FUNCTIONS
    
    // MARK: - GET ALL GAMES
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
    
    // MARK: - ADD ALL GAME
    func addNewGameData(newGame: Game) {
       do {
           let _ = try db.collection("game").addDocument(from: newGame)
       }
       catch {
           print(error)
       }
    }
    
    // MARK: - UPDATE GAME'S RATING LIST
    func updateGameRatinglist(documentID: String, ratingList: [Int]) {
        db.collection("game").document(documentID).updateData(["rating" : ratingList])
    }
    
    // MARK: - REMOVE GAME
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
