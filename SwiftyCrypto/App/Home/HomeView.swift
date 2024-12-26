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
    @State private var showAddPortfolio: Bool = false
    
    var body: some View {
        VStack {
            HomeNavigationView(isShowingPortfolio: $isShowingPortfolio) {
                showAddPortfolio.toggle()
            }
            .sheet(isPresented: $showAddPortfolio) {
                PortfolioView()
                    .environmentObject(viewModel)
            }
            HomeStatsView(showPortfolio: $isShowingPortfolio)
            SearchBarView(searchText: $viewModel.searchText)
            columnTitles
            if !isShowingPortfolio {
                CoinListView(coins: viewModel.coins)
                    .transition(.move(edge: .leading))
            } else {
                portFolioCoinsList
                    .transition(.move(edge: .trailing))
            }
        }
    }
}

extension HomeView {
    private var columnTitles: some View {
        HStack {
            Text("Coin")
            Spacer()
            if isShowingPortfolio {
                Text("Holdings")
            }
            Text("Price")
            .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
        }
        .font(.caption)
        .foregroundColor(Color.secondaryText)
        .padding(.horizontal)
    }
}

extension HomeView {
    private var portFolioCoinsList: some View {
        List {
            ForEach(viewModel.portfolioCoins) { coin in
                CoinRowView(coin: coin, showHoldingsColumn: true)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                    .listRowBackground(Color.background)
            }
        }
        .listStyle(PlainListStyle())
    }
}
