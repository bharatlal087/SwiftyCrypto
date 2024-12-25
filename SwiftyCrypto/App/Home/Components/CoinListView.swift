//
//  CoinListView.swift
//  SwiftyCrypto
//
//  Created by Bharat Lal on 24/12/24.
//

import SwiftUI

struct CoinListView: View {
    let coins: [Coin]
    
    var body: some View {
        List(coins) { coin in
            CoinRowView(coin: coin, showHoldingsColumn: false)
                .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                .listRowBackground(Color.background)
        }
        .listStyle(PlainListStyle())
    }
}

struct CoinRowView: View {
    let coin: Coin
    let showHoldingsColumn: Bool

    var body: some View {
        HStack(spacing: .zero) {
            leftContent
            Spacer()
            if showHoldingsColumn {
                middleContent
            }
            rightContent
        }
    }
}

extension CoinRowView {
    private var leftContent: some View {
        HStack(spacing: .zero) {
            Text("\(coin.rank)")
                .font(.caption)
                .foregroundColor(Color.secondaryText)
                .frame(minWidth: 30)
            
            CoinImageView(coin)
                .frame(width: 30, height: 30)
            
            Text(coin.symbol.uppercased())
                .font(.headline)
                .padding(.leading, 6)
                .foregroundColor(Color.accentColor)
        }
    }

    private var middleContent: some View {
        VStack(alignment: .trailing) {
            Text(coin.currentHoldingsValue.asCurrencyWith2Decimals())
                .bold()
            Text((coin.currentHoldings ?? 0).asNumberString())
        }
        .foregroundColor(Color.accentColor)
    }

    private var rightContent: some View {
        VStack(alignment: .trailing) {
            Text(coin.currentPrice.asCurrencyWith6Decimals())
                .bold()
                .foregroundColor(Color.accentColor)
            Text(coin.priceChangePercentage24H?.asPercentString() ?? "")
                .foregroundColor(
                    (coin.priceChangePercentage24H ?? 0 >= 0) ?
                    Color.appGreen :
                        Color.appRed
                )
        }
        .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
    }
}
