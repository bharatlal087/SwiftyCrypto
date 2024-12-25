//
//  MarketDataService.swift
//  SwiftyCrypto
//
//  Created by Bharat Lal on 25/12/24.
//

import Foundation
import Combine

final class MarketDataService {
    @Published var marketData: MarketData? = nil
    var marketDataSubscription: AnyCancellable?

    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    init() {
        getMarketData()
    }

    private func getMarketData() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else { return }
        marketDataSubscription = NetworkManager.execute(url)
            .decode(type: GlobalData.self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: { [weak self] receivedData in
                self?.marketData = receivedData.data
                self?.marketDataSubscription?.cancel()
            })
    }
}
