//
//  CoinImageViewModel.swift
//  CryptoTracker
//
//  Created by Maryam Kaveh on 3/24/1402 AP.
//

import Foundation
import SwiftUI
import Combine

class CoinImageViewmodel: ObservableObject {
    @Published var image: UIImage?
    @Published var isLoading: Bool = false
    private let coin: CoinModel
    
    private let dataService: CoinImageService?
    private var cancellables = Set<AnyCancellable>()
    
    init(coin: CoinModel) {
        self.coin = coin
        self.dataService = CoinImageService(coin: coin)
        self.isLoading = true
        addSubscribers()
    }
    
    private func addSubscribers() {
        dataService?.$image
            .sink(receiveCompletion: { [weak self] _ in
                self?.isLoading = false
            }, receiveValue: {[weak self] receivedImage in
                self?.image = receivedImage
            })
            .store(in: &cancellables)
    }
}
