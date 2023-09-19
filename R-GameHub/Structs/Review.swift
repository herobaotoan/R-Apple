//
//  Review.swift
//  R-GameHub
//
//  Created by Стивен on 19/09/2023.
//

import SwiftUI

struct Review: Identifiable {
    var id = UUID()
    var user: User
//    var game: Game
    var description: String
    var score: Double
}

let reviews = [
    Review(user: User(name: "a"), description: "Cool game.", score: 4.5),
    Review(user: User(name: "b"), description: "Nice execution.", score: 4)
]
