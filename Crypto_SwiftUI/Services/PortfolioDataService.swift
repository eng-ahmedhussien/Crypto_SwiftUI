//
//  PortfolioDataService.swift
//  Crypto_SwiftUI
//
//  Created by DBS on 23/05/2023.
//

import Foundation
import CoreData

class PortfolioDataService {
    
    private let container : NSPersistentContainer
    private let containerName: String = "PortfolioModel"
    private let entityName: String = "PortfolioEntity"
    @Published var dataFetched : [PortfolioEntity] = []
    
    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { (_, error) in
            if let error = error {
                print("Error loading Core Data! \(error)")
            }
            self.fetchData()
        }
    }
    
    func updatePortfolio(coin: CoinModel, amount: Double) {
        // check if coin is already in portfolio
        if let entity = dataFetched.first(where: { $0.coidID == coin.id }) {
            if amount > 0 {
                updateItem(entity: entity, amount: amount)
            } else {
                deleteItems(entity: entity)
            }
        } else {
            addData(coin: coin, amount: amount)
        }
    }
    
    private func fetchData(){
        let request = NSFetchRequest<PortfolioEntity>(entityName:entityName)
        do{
            dataFetched = try container.viewContext.fetch(request)
        }catch let error{
            print("fetching error \(error)")
        }
    }
    private func addData(coin:CoinModel,amount:Double){
        let newItem = PortfolioEntity(context: container.viewContext)
        newItem.coidID = coin.id
        newItem.amount = amount
        saveData()
        
    }
    private func updateItem(entity:PortfolioEntity,amount:Double){
        entity.amount = amount
        saveData()
    }
    private func deleteItems(entity: PortfolioEntity) {
        container.viewContext.delete(entity)
        saveData()
    }
    private func saveData(){
        do{
            try container.viewContext.save()
            fetchData()
        }catch let error{
            print("unsave data error \(error)")
        }
    }
    
}



