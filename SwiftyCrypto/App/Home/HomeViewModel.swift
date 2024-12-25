//
//  HomeViewModel.swift
//  SwiftyCrypto
//
//  Created by Bharat Lal on 24/12/24.
//

import Combine

final class HomeViewModel: ObservableObject {
    @Published var coins: [Coin] = []
    
    private let service = CoinService()
    private var cancellable = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }

    private func addSubscribers() {
        service.$coins
            .sink { [weak self] coins in
                self?.coins = coins
            }
            .store(in: &cancellable)
    }
}
