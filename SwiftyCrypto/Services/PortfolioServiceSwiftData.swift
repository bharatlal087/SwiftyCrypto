//
//  PortfolioServiceSwiftData.swift
//  SwiftyCrypto
//
//  Created by Bharat Lal on 26/12/24.
//

import Foundation
import SwiftData

final class PortfolioServiceSwiftData {
    @Published var savedEntities: [Portfolio] = []
    
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext
    
    @MainActor
    static let shared = PortfolioServiceSwiftData()
    @MainActor
    private init() {
        modelContainer = try! ModelContainer(for: Portfolio.self, configurations: ModelConfiguration(isStoredInMemoryOnly: false))
        modelContext = modelContainer.mainContext
        getPortfolio()
    }
    
    
     // MARK: PUBLIC
     
     func updatePortfolio(coin: Coin, amount: Double) {
         // check if coin is already in portfolio
         if let entity = savedEntities.first(where: { $0.coinId == coin.id }) {
             if amount > 0 {
                 update(entity: entity, amount: amount)
             } else {
                 delete(entity: entity)
             }
         } else {
             add(coin: coin, amount: amount)
         }
     }
     
     // MARK: PRIVATE

     private func getPortfolio() {
         do {
             savedEntities = try modelContext.fetch(FetchDescriptor<Portfolio>())
         } catch  {
             print(error.localizedDescription)
         }
     }

     private func add(coin: Coin, amount: Double) {
         let entity = Portfolio(coinId: coin.id, amount: amount)
         modelContext.insert(entity)
         applyChanges()
     }
     
     private func update(entity: Portfolio, amount: Double) {
         entity.amount = amount
         applyChanges()
     }
     
     private func delete(entity: Portfolio) {
         modelContext.delete(entity)
         applyChanges()
     }
     
     private func save() {
         do {
             try modelContext.save()
         } catch let error {
             print("Error saving to SwiftData. \(error)")
         }
     }
     
     private func applyChanges() {
         save()
         getPortfolio()
     }
}
