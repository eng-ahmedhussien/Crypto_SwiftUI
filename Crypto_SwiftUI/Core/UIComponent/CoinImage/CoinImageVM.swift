//
//  File.swift
//  Crypto_SwiftUI
//
//  Created by DBS on 16/05/2023.
//

import Foundation
import Combine
import UIKit

class CoinImageVM:ObservableObject{
    
    @Published var coinImage : UIImage?   = nil
    @Published var isLoading : Bool   = false
    
    private var imageService : ImageDataService
    private var cancellable = Set<AnyCancellable>()
    
    init(coin:CoinModel){
        self.isLoading = true
        self.imageService = ImageDataService(coin: coin)
        getImage()
    }
    func getImage(){
        imageService.$coinImage.sink { [weak self] data in
            self?.isLoading = false
            self?.coinImage = data
        }
        .store(in: &cancellable)

    }
    
    
}
