//
//  ContentView.swift
//  SwiftyCrypto
//
//  Created by Bharat Lal on 24/12/24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var viewModel: HomeViewModel
    @State private var isShowingPortfolio: Bool = false
    
    var body: some View {
        VStack {
            HomeNavigationView(isShowingPortfolio: $isShowingPortfolio)
            Spacer()
            CoinListView(coins: viewModel.coins)
        }
    }
}
