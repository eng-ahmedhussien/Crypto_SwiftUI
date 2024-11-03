//
//  imageDataService.swift
//  Crypto_SwiftUI
//
//  Created by DBS on 16/05/2023.
//

import Foundation
import Combine
import UIKit

class ImageDataService{
    
    @Published var coinImage : UIImage? = nil
    var  cancellable = Set<AnyCancellable>()
    private let coin: CoinModel
   // private let fileManager = LocalFileManger.shared
    private let folderName = "coin_images"
    private let imageName: String
    
    init(coin: CoinModel) {
        self.coin = coin
        self.imageName = coin.id
        getCoinImage()
    }
    private func getCoinImage() {
        if let savedImage =   LocalFileManager.instance.getImage(imageName: imageName, folderName: folderName){
            coinImage = savedImage
        } else {
            downloadCoinImage()
        }
    }

    private  func downloadCoinImage()  {

        guard let url = URL(string: coin.image) else {return}
        NetworkManger.download(url: url)
            .tryMap({ (data) -> UIImage? in
                return UIImage(data: data)
            })
            .sink { Completion in
                switch Completion{
                case .finished:
                    print("finshed recive")
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { [ weak self] returnedImage in
                guard let self = self, let downloadedImage = returnedImage else { return }
                self.coinImage = downloadedImage
                LocalFileManager.instance.saveIamgeInFileManger(image: downloadedImage, imageName: self.imageName, folderName: self.folderName)
            }
            .store(in: &cancellable)
    }
}
