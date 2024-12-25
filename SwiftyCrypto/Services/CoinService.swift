//
//  CoinService.swift
//  SwiftyCrypto
//
//  Created by Bharat Lal on 24/12/24.
//

import Foundation
import Combine

final class CoinService {
    @Published var coins: [Coin] = []
    
    private var coinSubscription: AnyCancellable?

    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    init() {
        getCoins()
    }

    private func getCoins() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h") else { return }
        coinSubscription = NetworkManager.execute(url)
            .decode(type: [Coin].self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkManager.handleCompletion) { [weak self] coins in
                self?.coins = coins
                self?.coinSubscription?.cancel()
            }
    }
}
