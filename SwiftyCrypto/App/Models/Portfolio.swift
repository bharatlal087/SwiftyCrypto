//
//  Portfolio.swift
//  SwiftyCrypto
//
//  Created by Bharat Lal on 26/12/24.
//

import Foundation
import SwiftData

@Model
final class Portfolio {
    var coinId: String
    var amount: Double
    
    init(coinId: String, amount: Double) {
        self.coinId = coinId
        self.amount = amount
    }
}
