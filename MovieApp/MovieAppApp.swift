//
//  MovieAppApp.swift
//  MovieApp
//
//  Created by Stanislav Bezsonov on 21/07/2025.
//

import SwiftUI

@main
struct MovieAppApp: App {
//    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MoviesCategoriesView()
        }
    }
}
