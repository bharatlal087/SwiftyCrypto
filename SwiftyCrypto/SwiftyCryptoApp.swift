//
//  SwiftyCryptoApp.swift
//  SwiftyCrypto
//
//  Created by Bharat Lal on 24/12/24.
//

import SwiftUI

@main
struct SwiftyCryptoApp: App {
    @StateObject private var homeViewModel = HomeViewModel()
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                HomeView()
                    .toolbar(.hidden)
            }
            .environmentObject(homeViewModel)
        }
    }
}
