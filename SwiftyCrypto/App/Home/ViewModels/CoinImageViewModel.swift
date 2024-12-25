//
//  CoinImageViewModel.swift
//  SwiftyCrypto
//
//  Created by Bharat Lal on 25/12/24.
//

import SwiftUI
import Combine

final class CoinImageViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = false
    
    private let coin: Coin
    private let service: ImageService
    private var cancellable = Set<AnyCancellable>()
    
    init(_ coin: Coin) {
        self.coin = coin
        self.service = .init(id: coin.id, urlString: coin.image)
        self.isLoading = true
        addSubscribers()
    }

    private func addSubscribers() {
        service.$image
            .sink { [weak self] _ in
                self?.isLoading = false
            } receiveValue: { [weak self] image in
                self?.image = image
            }
            .store(in: &cancellable)
    }
}
