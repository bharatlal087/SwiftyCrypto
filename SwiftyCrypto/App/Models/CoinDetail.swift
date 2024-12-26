//
//  CoinDetail.swift
//  SwiftyCrypto
//
//  Created by Bharat Lal on 26/12/24.
//


struct CoinDetail: Codable {
    let id, symbol, name: String?
    let blockTimeInMinutes: Int?
    let hashingAlgorithm: String?
    let description: Description?
    let links: Links?

    var readableDescription: String? {
        nil
        //return description?.en?.removingHTMLOccurances
    }
}

struct Links: Codable {
    let homepage: [String]?
    let subredditURL: String?
}

struct Description: Codable {
    let en: String?
}
