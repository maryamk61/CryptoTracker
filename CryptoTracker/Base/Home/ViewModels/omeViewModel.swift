//
//  omeViewModel.swift
//  CryptoTracker
//
//  Created by Maryam Kaveh on 11/25/1401 AP.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var statistics: [StatisticModel] = []
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    @Published var searchText: String = ""
    @Published var sortOption: SortOption = .holdings
    
    private var coinDataService: CoinDataService = CoinDataService()
    private var marketDataService: MarketDataService = MarketDataService()
    private let portfolioDataService: PortfolioDataService = PortfolioDataService()
    
    private var cancellables = Set<AnyCancellable>()
    
    enum SortOption {
        case rank, rankReversed, holdings, holdingsReversed, price, priceReversed
    }
    
    init() {
        // The allCoins in this viewModel must subscribe to allCoin in dataService to get updated.
        addSubScribers()
    }
    
    func addSubScribers() {
        // We do not need this publisher anymore , because we are subscribing to this publisher and searchText together down here
        
        //        dataService.$allCoins
        //            .sink { [weak self] returnedCoins in
        //                self?.allCoins = returnedCoins
        //            }
        //            .store(in: &cancellables)
        
        $searchText
            .combineLatest(coinDataService.$allCoins, $sortOption)
            .debounce(for: .seconds(0.5) , scheduler: DispatchQueue.main) // wait for 0.5 secs
            .map(filterAndSortCoins) // we can delete parameters because they are exact same
            .sink { [weak self] returnedCoins in
                guard let self = self else {return}
                // sort portfolioCoins if needed, because allCoins is already sorted
                self.allCoins =  returnedCoins
            }
            .store(in: &cancellables)
        
        // Better to use seperate func for map
        //            .map { (text, startingCoins) -> [CoinModel] in
        //                guard !text.isEmpty else {
        //                    return startingCoins
        //                }
        //                let lowerCased = text.lowercased()
        //                return startingCoins.filter { coin -> Bool in
        //                    return coin.name.lowercased().contains(lowerCased) ||
        //                    coin.id.lowercased().contains(lowerCased) ||
        //                    coin.symbol.lowercased().contains(lowerCased)
        //                }
        //            }
        //            .sink { [weak self] returnedCoins in
        //                self?.allCoins =  returnedCoins
        //            }
        //            .store(in: &cancellables)
        
        //update portfolio
        $allCoins
            .combineLatest(portfolioDataService.$savedEntities)
            .map(mapAllCoinsToPortfolioCoins)
            .sink { [weak self] returnedCoins in
                guard let self = self else {return}
                // sort portfolioCoins if needed, because allCoins is already sorted
                self.portfolioCoins = self.sortPortfolioCoins(coins: returnedCoins)
            }
            .store(in: &cancellables)
        
        //updates market data (and portfolio value)
        marketDataService.$marketData
            .combineLatest($portfolioCoins)
            .map(mapGlobalMarketData) // better to shorten it
            .sink { [weak self] stats in
                self?.statistics = stats
            }
            .store(in: &cancellables)
    }
    
    private func filterAndSortCoins(text: String, coins: [CoinModel], sortOption: SortOption) -> [CoinModel] {
        var updatedCoins = filterCoin(text: text, coins: coins)
        //sort using inout parameter
        sortCoins(sortOption: sortOption, coins: &updatedCoins)
        return updatedCoins
    }
    
    private func filterCoin(text: String, coins: [CoinModel]) -> [CoinModel] {
        guard !text.isEmpty else {
            return coins
        }
        let lowerCased = text.lowercased()
        return coins.filter { coin -> Bool in
            return coin.name.lowercased().contains(lowerCased) ||
            coin.id.lowercased().contains(lowerCased) ||
            coin.symbol.lowercased().contains(lowerCased)
        }
    }
    
    private func sortCoins(sortOption: SortOption, coins: inout [CoinModel]) {// (inout)to sort this array inplace , means return the same array not new array, so we delete the return type(more eficient)
        switch sortOption {
        case .rank, .holdings: // we don't have holdings option in allCoins, so we don't care
            coins.sort(by: {$0.rank < $1.rank})
        case .rankReversed, .holdingsReversed:
            coins.sort(by: {$0.rank > $1.rank})
        case .price:
            coins.sort(by: {$0.currentPrice > $1.currentPrice})
        case .priceReversed:
            coins.sort(by: {$0.rank < $1.rank})
        }
    }
    
    func sortPortfolioCoins(coins: [CoinModel]) -> [CoinModel] {
        //will only sort by holdings or holdingsReversed
        switch sortOption {
        case .holdings:
            return coins.sorted(by: {$0.currentHoldingValue > $1.currentHoldingValue})
        case .holdingsReversed:
            return coins.sorted(by: {$0.currentHoldingValue < $1.currentHoldingValue})
        default:
            return coins
        }
    }
    func updatePortfolio(coin: CoinModel, amount: Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    private func mapAllCoinsToPortfolioCoins(allCoins: [CoinModel], portfolioEntities: [PortfolioEntity]) -> [CoinModel] {
        allCoins.compactMap { coin -> CoinModel? in
            guard let entity = portfolioEntities.first(where: { $0.coinId == coin.id }) else {
                return nil
            }
            return coin.updateHoldings(amount: entity.amout)
        }
    }
    
    private func mapGlobalMarketData(data: MarketDataModel?, portfolioCoins: [CoinModel] ) -> [StatisticModel]  {
        var stats: [StatisticModel] = []
        guard let data = data else {
            return stats
        }
        
        let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = StatisticModel(title: "24h Volume", value: data.volume)
        let dominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
        
        let portfolioValue = portfolioCoins.map { $0.currentHoldingValue}
            .reduce(0, +)
        
        let previousValue = portfolioCoins.map { coin -> Double in
            let currentValue = coin.currentHoldingValue
            let percentChange =  (coin.priceChangePercentage24H ?? 0) / 100
            let previousValue = currentValue / (1 + percentChange)
            return previousValue
        }.reduce(0, +)
        
        let percentageChange = ((portfolioValue - previousValue) / previousValue)
        
        let portfolio = StatisticModel(
            title: "Portfolio Value",
            value: portfolioValue.asCurrencyWith2Decimals() ,
            percentageChange: percentageChange)
        
        stats.append(contentsOf: [
            marketCap,
            volume,
            dominance,
            portfolio
        ])
        return stats
    }
    
    func reloadData() {
        coinDataService.getCoins()
        marketDataService.getData()
        //refreshable has the haptic manager itself so when it wasn't released we used this method
//        HapticManager.notification(type: .error)
    }
}




