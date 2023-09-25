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
import FirebaseFirestoreSwift

struct User: Codable, Identifiable {
    var uid: String = UUID().uuidString
    var id: String
    var name: String
    var email: String
    var phone: String
    var imageURL: String
    @DocumentID var documentID: String?
}
