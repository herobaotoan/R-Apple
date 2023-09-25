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

class ReviewViewModel: ObservableObject {
 
    // MARK: - PROPERTIES
    @Published var reviews = [Review]()
    private var db = Firestore.firestore()

    init() {
        getAllReviewData()
    }
 
    // MARK: - FUNCTIONS
 
    // MARK: - GET ALL REVIEWS
    func getAllReviewData() {
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
 
     // MARK: - ADD NEW REVIEW
    func addNewReviewData(newReview: Review) {
        do {
            let _ = try db.collection("review").addDocument(from: newReview)
        }
        catch {
            print(error)
        }
    }
}
