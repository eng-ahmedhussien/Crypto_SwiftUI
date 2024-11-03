//
//  CoinDataService.swift
//  Crypto_SwiftUI
//
//  Created by DBS on 16/05/2023.
//

import Foundation
import Combine

class CoinDataService{
    
    @Published var allCoins : [CoinModel] = []
    var  cancellable = Set<AnyCancellable>()
    
    init(){
        fetchDate()
    }
    func fetchDate()  {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h")
        else{return}
        
        NetworkManger.download(url: url)
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .sink{ Completion in
                switch Completion{
                case .finished:
                    print("finshed recive all coins")
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { [ weak self] retaurnedCoin in
                self? .allCoins = retaurnedCoin
            }
            .store(in: &cancellable)
    }
}
