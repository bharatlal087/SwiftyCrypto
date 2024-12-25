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
            CoinRow(coin)
                .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                .listRowBackground(Color.background)
        }
        .listStyle(PlainListStyle())
    }

    private func CoinRow(_ coin: Coin) -> some View {
        HStack {
            Text("\(coin.rank)")
                .font(.caption)
                .foregroundColor(Color.secondaryText)
                .frame(minWidth: 30)
            
            Circle().fill(Color.black)
                .frame(width: 30, height: 30)
            
            Text(coin.symbol.uppercased())
                .font(.headline)
                .padding(.leading, 6)
                .foregroundColor(Color.accentColor)
        }
    }

    
}
