//
//  DetailViewModel.swift
//  CryptoTracker
//
//  Created by Maryam Kaveh on 4/21/1402 AP.
//

import Foundation
import Combine

class CoinDetailViewModel: ObservableObject {
    
    @Published var coin: CoinModel
    private let coinDetailService: CoinDetailDataService
    @Published var coinDetails: CoinDetailModel?
    private var cancellables = Set<AnyCancellable>()
    @Published var overviewStatistics: [StatisticModel] = []
    @Published var additionalStatistics: [StatisticModel] = []
    
    init(coin: CoinModel) {
        self.coin = coin
        self.coinDetailService = CoinDetailDataService(coin: coin)
        self.addSubscribers()
    }
    
    private func addSubscribers() {
        coinDetailService.$coinDetails
            .combineLatest($coin)
            .map({ (coinDetailModel, coinModel) -> (overview: [StatisticModel], additional: [StatisticModel]) in
                
                //overview array
                let price = coinModel.currentPrice.asCurrencyWith6Decimals()
                let pricePercentChange = coinModel.priceChangePercentage24H
                let priceStat = StatisticModel(title: "Current Price", value: price, percentageChange: pricePercentChange)
                
                let marketCap = "$" + (coinModel.marketCap?.formattedWithAbbreviations() ?? "")
                let marketPercentageChange = coinModel.marketCapChangePercentage24H
                let marketStat = StatisticModel(title: "Market Capitalization", value: marketCap, percentageChange: marketPercentageChange)
                
                let rank = "\(coinModel.rank)"
                let rankStat = StatisticModel(title: "Rank", value: rank)
                
                let volume = "$" + (coinModel.totalVolume?.formattedWithAbbreviations() ?? "")
                let volumeStat = StatisticModel(title: "Volume", value: volume)
                    
                var overview: [StatisticModel] = [
                    priceStat, marketStat, rankStat, volumeStat
                ]
                
                //additional
                let high = coinModel.high24H?.asCurrencyWith6Decimals() ?? "n/a"
                let highStat = StatisticModel(title: "24H High", value: high)
                
                let low = coinModel.low24H?.asCurrencyWith6Decimals() ?? "n/a"
                let lowStat = StatisticModel(title: "24H Low", value: low)
                
                let priceChange = coinModel.priceChange24H?.asCurrencyWith6Decimals() ?? "n/a"
                let pricePercentChange2 = coinModel.priceChangePercentage24H
                let priceChangeStat = StatisticModel(title: "24H Price Change ", value: priceChange, percentageChange: pricePercentChange2)
                
                let marketCapChange = "$" + (coinModel.marketCapChange24H?.formattedWithAbbreviations() ?? "")
                let marketCapPercentageChange = coinModel.marketCapChangePercentage24H
                let marketCapChangeStat = StatisticModel(title: "24H Market Cap Change", value: marketCapChange, percentageChange: marketPercentageChange)
                
                let blockTime = coinDetailModel?.blockTimeInMinutes ?? 0
                let blocktimeString = blockTime == 0 ? "n/a" : "\(blockTime)"
                let blockTimeStat = StatisticModel(title: "Block Time", value: blocktimeString)
                
                let hashing = coinDetailModel?.hashingAlgorithm ?? "n/a"
                let hashingStat = StatisticModel(title: "Hashing Algorithm", value: hashing)
                
                let additionalArray: [StatisticModel] = [
                    highStat, lowStat, priceChangeStat, marketCapChangeStat, blockTimeStat, hashingStat
                ]
                
                return (overview, additionalArray)
            })
            .sink { [weak self] returnedArrays in
                self?.overviewStatistics = returnedArrays.overview
                self?.additionalStatistics = returnedArrays.additional
            }
            .store(in: &cancellables)
    }
}
