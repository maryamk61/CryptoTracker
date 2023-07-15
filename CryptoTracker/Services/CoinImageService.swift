//
//  CoinImageService.swift
//  CryptoTracker
//
//  Created by Maryam Kaveh on 12/17/1401 AP.
//

import Foundation
import SwiftUI
import Combine

class CoinImageService {
    
    @Published var image: UIImage?
    private var coinImageSubcription: AnyCancellable?
    
    private let coin: CoinModel
    private var fileManager = LocalFileManager.instance
    private let folderName = "coin_images"
    
    init(coin: CoinModel) {
        self.coin = coin
        getCoinImage()
    }
    
    private func getCoinImage() {
        // first from fileManager then if not exists, download
        if let savedimage = fileManager.getImage(imageName: coin.id, folderName: folderName) {
            image = savedimage
        } else {
            DownloadCoinImage()
        }
    }
    
    private func DownloadCoinImage() {
        guard let url = URL(string: coin.image) else {return}
        
        coinImageSubcription = NetworkingManager.download(url: url)
            .tryMap({ (data) ->  UIImage? in
                return UIImage(data: data)
            })
            .sink(receiveCompletion: {_ in }, receiveValue: {[weak self] (returnedImage) in
                guard let self = self , let downloadedimage = returnedImage else {return}
                self.image = downloadedimage
                self.fileManager.saveImage(image: downloadedimage, imageName: self.coin.id, folderName: self.folderName )
                self.coinImageSubcription?.cancel()
            })
    }
}
