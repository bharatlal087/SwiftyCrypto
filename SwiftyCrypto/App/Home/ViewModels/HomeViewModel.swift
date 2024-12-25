//
//  HomeViewModel.swift
//  SwiftyCrypto
//
//  Created by Bharat Lal on 24/12/24.
//

import Combine
import Foundation

final class HomeViewModel: ObservableObject {
    @Published var coins: [Coin] = []
    @Published var statistics: [Statistic] = []
    @Published var searchText: String = ""
    
    private let service = CoinService()
    private let marketService = MarketDataService()
    private var cancellable = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }

    private func addSubscribers() {
//        service.$coins
//            .sink { [weak self] coins in
//                self?.coins = coins
//            }
//            .store(in: &cancellable)

        $searchText.combineLatest(service.$coins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterCoins)
            .sink { [weak self] coins in
                self?.coins = coins
            }
            .store(in: &cancellable)
    
        marketService.$marketData
            .map(mapGlobalData)
            .sink { [weak self] stats in
                self?.statistics = stats
            }
            .store(in: &cancellable)
    }

    private func mapGlobalData(data: MarketData?) -> [Statistic] {
        var stats = [Statistic]()
        guard let data else { return stats }
        let marketCap = Statistic(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = Statistic(title: "24h Volume", value: data.volume)
        let btcDominance = Statistic(title: "BTC Dominance", value: data.btcDominance)
        let portfolioValue = Statistic(title: "Portfolio Value", value: "$0.00", percentageChange: 0)
        
        stats.append(contentsOf: [marketCap, volume, btcDominance, portfolioValue])
        return stats
    }

    private func filterCoins(text: String, coins: [Coin]) -> [Coin] {
        guard !text.isEmpty else {
            return coins
        }
        
        let lowercasedText = text.lowercased()
        
        return coins.filter { (coin) -> Bool in
            return coin.name.lowercased().contains(lowercasedText) ||
                    coin.symbol.lowercased().contains(lowercasedText) ||
                    coin.id.lowercased().contains(lowercasedText)
        }
    }
}
