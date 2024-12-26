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
    @Published var portfolioCoins: [Coin] = []
    @Published var searchText: String = ""
    
    private let service = CoinService()
    private let marketService = MarketDataService()
    private let portfolioService: PortfolioServiceSwiftData
//    private let portfolioCDService = PortfolioDataServiceCD()
    private var cancellable = Set<AnyCancellable>()
    
    @MainActor
    init() {
        self.portfolioService = PortfolioServiceSwiftData.shared
        addSubscribers()
    }

    // MARK: - Public
    
    func updatePortfolio(coin: Coin, amount: Double) {
//        portfolioCDService.updatePortfolio(coin: coin, amount: amount)
        portfolioService.updatePortfolio(coin: coin, amount: amount)
    }
    
    // MARK: - Private

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
    
//        marketService.$marketData
//            .map(mapGlobalData)
//            .sink { [weak self] stats in
//                self?.statistics = stats
//            }
//            .store(in: &cancellable)
        marketService.$marketData
            .combineLatest($portfolioCoins)
            .map(mapGlobalData)
            .sink { [weak self] (returnedStats) in
                self?.statistics = returnedStats
            }
            .store(in: &cancellable)
        
        // Update portfolio - CoreData
//        $coins.combineLatest(portfolioCDService.$savedEntities)
//            .map { coins, entities in
//                coins.compactMap { (coin) -> Coin? in
//                    guard let entity = entities.first(where: { $0.coinID == coin.id }) else { return nil }
//                    return coin.updateHoldings(amount: entity.amount)
//                }
//            }
//            .sink { [weak self] coins in
//                self?.portfolioCoins = coins
//            }
//            .store(in: &cancellable)
        
        // Update portfolio - SwiftData
        $coins.combineLatest(portfolioService.$savedEntities)
            .map { coins, entities in
                coins.compactMap { (coin) -> Coin? in
                    guard let entity = entities.first(where: { $0.coinId == coin.id }) else { return nil }
                    return coin.updateHoldings(amount: entity.amount)
                }
            }
            .sink { [weak self] coins in
                self?.portfolioCoins = coins
            }
            .store(in: &cancellable)
    }

    private func mapGlobalData(data: MarketData?, portfolioCoins: [Coin]) -> [Statistic] {
        var stats: [Statistic] = []
        
        guard let data else {
            return stats
        }
        
        let marketCap = Statistic(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = Statistic(title: "24h Volume", value: data.volume)
        let btcDominance = Statistic(title: "BTC Dominance", value: data.btcDominance)
        
        let portfolioValue =
        portfolioCoins
            .map({ $0.currentHoldingsValue })
            .reduce(0, +)
        
        let previousValue =
        portfolioCoins
            .map { (coin) -> Double in
                let currentValue = coin.currentHoldingsValue
                let percentChange = coin.priceChangePercentage24H ?? 0 / 100
                let previousValue = currentValue / (1 + percentChange)
                return previousValue
            }
            .reduce(0, +)
        
        let percentageChange = ((portfolioValue - previousValue) / previousValue)
        
        let portfolio = Statistic(
            title: "Portfolio Value",
            value: portfolioValue.asCurrencyWith2Decimals(),
            percentageChange: percentageChange)
        
        stats.append(contentsOf: [
            marketCap,
            volume,
            btcDominance,
            portfolio
        ])
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
