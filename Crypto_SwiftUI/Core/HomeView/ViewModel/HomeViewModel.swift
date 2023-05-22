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
    @Published var portfolioCoins : [CoinModel] = []
    @Published var searchText = ""
    @Published var statistics: [StatisticModel] = []
    
    
    private var coinDataService = CoinDataService()
    private var markedDataService = MarketDataService()
    private var cancellable = Set<AnyCancellable>()
    
    init(){
        subscribfunc()
    }
    
    func subscribfunc(){
        
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
        
        
        // updates marketData
        markedDataService.$MarketDate
            .map(mapGlobalMarketData)
            .sink { [weak self] (returnedStats) in
                self?.statistics = returnedStats
               // self?.isLoading = false
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
    
    func mapGlobalMarketData(marketDataModel: MarketDataModel?) -> [StatisticModel]{
        var stata : [StatisticModel] = []
        guard let data = marketDataModel else {
            return stata
        }
        
        let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = StatisticModel(title: "24h Volume", value: data.volume)
        let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
        let portfolioValue =  StatisticModel(title: "Portfolio Value", value: "$00.0", percentageChange: 0)
        
        stata.append(contentsOf: [
            marketCap,
            volume,
            btcDominance,
            portfolioValue
        ])
        return stata
    }
    
    
    func subscribfuncWithMe(){
        
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
