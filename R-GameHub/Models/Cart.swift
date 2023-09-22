//
//  User.swift
//  Cafe
//
//  Created by Toan Tran Chi on 13/09/2023.
//

import Foundation

struct Cart: Codable, Identifiable {
    var id: String = UUID().uuidString
    var uid: String
    var gameID: [String]
    var documentID: String?
}
