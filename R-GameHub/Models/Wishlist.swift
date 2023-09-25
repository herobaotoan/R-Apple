//
//  Wishlist.swift
//  R-GameHub
//
//  Created by Nguyen Thi Ha Giang on 25/09/2023.
//

import Foundation

struct Wishlist: Codable, Identifiable {
    var id: String = UUID().uuidString
    var uid: String
    var gameID: [String]
    var documentID: String?
}
