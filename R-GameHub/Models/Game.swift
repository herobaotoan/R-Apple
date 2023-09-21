//
//  Game.swift
//  R-GameHub
//
//  Created by Toan Tran Chi on 19/09/2023.
//

import Foundation

 struct Game: Codable, Identifiable {
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
