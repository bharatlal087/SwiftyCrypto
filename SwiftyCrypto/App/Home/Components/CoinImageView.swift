//
//  CoinImageView.swift
//  SwiftyCrypto
//
//  Created by Bharat Lal on 25/12/24.
//

import SwiftUI

struct CoinImageView: View {
    @StateObject var viewModel: CoinImageViewModel

    init(_ coin: Coin) {
        _viewModel = StateObject(wrappedValue: CoinImageViewModel(coin))
    }
    
    var body: some View {
        ZStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else if viewModel.isLoading {
                ProgressView()
            } else {
                Image(systemName: "questionmark")
                    .foregroundColor(Color.secondaryText)
            }
        }
    }
}
