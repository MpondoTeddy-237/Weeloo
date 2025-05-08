//
//  WeelooApp.swift
//  Weeloo
//
//  Created by TEDDY 237 on 22/04/2025.
//

import SwiftUI

@main
struct WeelooApp: App {
    @StateObject private var postViewModel = PostViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(postViewModel)
        }
    }
}
