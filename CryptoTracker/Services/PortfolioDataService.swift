//
//  PortfolioDataService.swift
//  CryptoTracker
//
//  Created by Maryam Kaveh on 4/14/1402 AP.
//

import Foundation
import CoreData

class PortfolioDataService {
    let container: NSPersistentContainer
    private let containerName: String  = "PortfolioContainer"
    private let entityName:String = "PortfolioEntity"
    
    @Published var savedEntities: [PortfolioEntity] = []
    
    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Error loading Core data: \(error)")
            }
            self.getPortfolio()
        }
    }
    // PUBLIC SECTION
    func updatePortfolio(coin: CoinModel, amount: Double) {
//        if let entity = savedEntities.first(where: { savedEntity  in
//            return coin.id == savedEntity.coinId
//        }) {
        
        //check if coin is already in portfolio
        if let entity = savedEntities.first(where: { $0.coinId == coin.id }) {
            if amount > 0 {
                update(entity: entity, amount: amount)
            } else {
                delete(entity: entity)
            }
        } else { // new entity
            add(coin: coin, amount: amount)
        }
    }
    
    // PRIVATE SECTION
    private func getPortfolio() {
        let request = NSFetchRequest<PortfolioEntity>(entityName: entityName)
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching portfolio entities: \(error)")
        }
    }
    
    private func add(coin: CoinModel, amount: Double) {
        let entity = PortfolioEntity(context: container.viewContext)
        entity.coinId = coin.id
        entity.amout = amount
        applyChanges()
    }
    
    private func update(entity: PortfolioEntity, amount: Double) {
        entity.amout = amount
        applyChanges()
    }
    
    private func delete(entity: PortfolioEntity) {
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    private func save() {
        do {
            try container.viewContext.save()
        } catch let error {
            print("Error saving core data: \(error)")
        }
    }
    
    private func applyChanges() {
        save()
        getPortfolio()
    }
}
