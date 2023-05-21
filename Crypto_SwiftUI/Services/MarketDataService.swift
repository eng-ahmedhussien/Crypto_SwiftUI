//
//  MarketDataService.swift
//  Crypto_SwiftUI
//
//  Created by DBS on 21/05/2023.
//

import Foundation
import Combine

class MarketDataService{
    
    @Published var MarketDate : MarketDataModel? = nil
    var  cancellable = Set<AnyCancellable>()
    
    init(){
        f etchDate()
    }
    
    private  func fetchDate()  {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global")
        else{return}
        
        NetworkManger.download(url: url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
          .sink{ Completion in
              switch Completion{
                  case .finished:
                      print("finshed recive all coins")
                  case .failure(let error):
                      print(error)
              }
          } receiveValue: { [ weak self] retaurnedData in
              self?.MarketDate = retaurnedData.data
          }
          .store(in: &cancellable)
    }
}
