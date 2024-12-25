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
    @Published var searchText: String = ""
    
    private let service = CoinService()
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
