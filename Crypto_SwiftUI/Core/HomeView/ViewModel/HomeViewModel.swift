//
//  HomeVM.swift
//  Crypto_SwiftUI
//
//  Created by DBS on 15/05/2023.
//

import Foundation
import Combine

class HomeViewModel:ObservableObject{
    
    @Published var allCoin : [CoinModel] = []
    @Published var portfolioCoin : [CoinModel] = []
    @Published var searchText = ""
    @Published var statistics: [StatisticModel] = [
        StatisticModel(title: "Market Cap", value: "$12.5Bn", percentageChange: 25.34),
        StatisticModel(title: "Total Volume", value: "$1.23Tr"),
        StatisticModel(title: "Portfolio Value", value: "$50.4k", percentageChange: -12.34),
        StatisticModel(title: "Total Volume", value: "$1.23Tr"),
   ]
    
    
    private var coinDataService = CoinDataService()
    private var cancellable = Set<AnyCancellable>()
    
    init(){
        //subscribToAllCoinWithMe()
        subscribToAllCoin()
        
    }
    
    func subscribToAllCoin(){
        
        //fiest subscrib modification
        /*
        coinDataService.$allCoins.sink {[weak self] data in
            self?.allCoin = data
        }.store(in: &cancellable)
        */
        
        //second subscrib modification
       /* $searchText
            .combineLatest(coinDataService.$allCoins)
            .map{(text,coins)->[CoinModel] in
                guard !text.isEmpty else{
                    return coins
                }
                let lowerSearchText  = text.lowercased()
                return coins.filter { returnedCoin  in
                    return returnedCoin.name.lowercased().contains(lowerSearchText) ||
                    returnedCoin.symbol.lowercased().contains(lowerSearchText) ||
                    returnedCoin.id.lowercased().contains(lowerSearchText)
                    
                }
            }
            .sink { returnedCoins in
                self.allCoin = returnedCoins
            }
            .store(in: &cancellable)
        */
        
        //thaird subscrib modification
        $searchText
            .combineLatest(coinDataService.$allCoins)
            .debounce(for:0.5 , scheduler: DispatchQueue.main)
            .map(filterCoins)
            .sink { returnedCoins in
                self.allCoin = returnedCoins
            }
            .store(in: &cancellable)
    }
    
    func filterCoins(text:String,coins:[CoinModel])->[CoinModel]{
        
        guard !text.isEmpty else{
            return coins
        }
        let lowerSearchText  = text.lowercased()
        return coins.filter { returnedCoin  in
            return returnedCoin.name.lowercased().contains(lowerSearchText) ||
            returnedCoin.symbol.lowercased().contains(lowerSearchText) ||
            returnedCoin.id.lowercased().contains(lowerSearchText)
            
        }
    }
    
    
    func subscribToAllCoinWithMe(){
        
        //MARK: usning map
        /*
         $searchText.sink {[weak self] text in
         guard let self = self else {return}
         self.coinDataService.$allCoins.map{(coins)->[CoinModel] in
         guard !text.isEmpty else{
         return coins
         }
         let lowerSearchText  = text.lowercased()
         return coins.filter { returnedCoin  in
         return returnedCoin.name.lowercased().contains(lowerSearchText) ||
         returnedCoin.symbol.lowercased().contains(lowerSearchText) ||
         returnedCoin.id.lowercased().contains(lowerSearchText)
         }
         }.sink{ returnedCoins in
         self.allCoin = returnedCoins
         }.store(in: &self.cancellable)
         }.store(in: &cancellable)
         */
        
        //MARK: usning filter
        /*
        $searchText.sink {[weak self] text in
            guard let self = self else {return}
            guard !text.isEmpty else{
                return self.coinDataService.$allCoins.sink {[weak self] data in
                    self?.allCoin = data
                }.store(in: &self.cancellable)
            }
            self.coinDataService.$allCoins.sink{ coins in
                self.allCoin = coins.filter { coin in
                    let lowerSearchText  = text.lowercased()
                    return coin.name.lowercased().contains(lowerSearchText) ||
                    coin.symbol.lowercased().contains(lowerSearchText) ||
                    coin.id.lowercased().contains(lowerSearchText)
                }
            }.store(in: &self.cancellable)
        }.store(in: &cancellable)
         */
         
        //MARK: using combineLatest
        /*
        $searchText
            .combineLatest(coinDataService.$allCoins)
            .map{(text,coins)->[CoinModel] in
                guard !text.isEmpty else{
                    return coins
                }
                let lowerSearchText  = text.lowercased()
                return coins.filter { returnedCoin  in
                    return returnedCoin.name.lowercased().contains(lowerSearchText) ||
                    returnedCoin.symbol.lowercased().contains(lowerSearchText) ||
                    returnedCoin.id.lowercased().contains(lowerSearchText)
                    
                }
            }
            .sink { returnedCoins in
                self.allCoin = returnedCoins
            }
            .store(in: &cancellable)
         */
        
    }
    
    
}
