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
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        appearance.backgroundColor = .clear

        let tabBar = UITabBar.appearance()
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(coordinator)
        }
    }
}
