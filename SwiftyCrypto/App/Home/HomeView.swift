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
            SearchBarView(searchText: $viewModel.searchText)
            if !isShowingPortfolio {
                CoinListView(coins: viewModel.coins)
            } else {
                portFolioCoinsList
            }
        }
    }
}

extension HomeView {
    private var portFolioCoinsList: some View {
        List {
            
        }
        .listStyle(PlainListStyle())
    }
}
