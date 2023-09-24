//
//  Review.swift
//  R-GameHub
//
//  Created by Toan Tran Chi on 19/09/2023.
//

import Foundation

struct Review: Codable, Identifiable {
    var id: String = UUID().uuidString
    var description: String
    var rating: Int
    var userID: String
    var gameID: String
    var documentID: String?
}

