//
//  User.swift
//  Cafe
//
//  Created by Toan Tran Chi on 13/09/2023.
//

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
