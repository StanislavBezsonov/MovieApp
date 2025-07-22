//
//  MovieAppApp.swift
//  MovieApp
//
//  Created by Stanislav Bezsonov on 21/07/2025.
//

import SwiftUI

@main
struct MovieAppApp: App {
    @StateObject private var coordinator = AppCoordinator()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(coordinator)
        }
    }
}
