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

 struct Game: Codable, Identifiable {
     
     // MARK: - PROPERTIES
     var id: String = UUID().uuidString
     var name: String
     var description: String
     var price: Double
     var platform: [String]
     var genre: [String]
     var developer: String
     var rating: [Int]
     var imageURL: String
     var userID: String
     var documentID: String?
 }
