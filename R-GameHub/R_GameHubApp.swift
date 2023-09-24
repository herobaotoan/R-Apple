//
//  R_GameHubApp.swift
//  R-GameHub
//
//  Created by Стивен on 15/09/2023.
//

import SwiftUI
import Firebase

@main
struct R_GameHubApp: App {
    @StateObject var userViewModel = UserViewModel()
    
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            LogInView()
//                .environmentObject(userViewModel)
        }
    }
}
