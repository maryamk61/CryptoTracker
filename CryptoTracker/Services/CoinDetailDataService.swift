//
//  CoinDetailDataService.swift
//  CryptoTracker
//
//  Created by Maryam Kaveh on 4/21/1402 AP.
//

// Services are usually 3rd party and utillities are usually internal stuff
import Foundation
import Combine

class CoinDetailDataService {
    @Published var coinDetails: CoinDetailModel? = nil
    //var cancellables = Set<AnyCancellable>() // It's hard to cancel this specific publisher if we want to because of Set, so we can use single Cancellable instead to cancel it any time we want.
    let coin: CoinModel
    var coinDetailSubscription: AnyCancellable? // Whenever we want to cancel the publisher we can use this way
    
    init(coin: CoinModel) {
        self.coin = coin
        getCoinDetails()
    }
    
    func getCoinDetails() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false") else {return}
        
        
        coinDetailSubscription = NetworkingManager.download(url: url)
            .decode(type: CoinDetailModel.self, decoder: JSONDecoder())
            .sink { (completion) in
                switch completion {
                case .failure(let error):
                    print(error.localizedDescription)
                    print(error)
                case .finished: // default
                    break
                }
            } receiveValue: { [weak self] (returnedDetails) in
                print("Get coin details successfully!")
                guard let self = self else {return} // or self?.allCoins = returnedCoins
                self.coinDetails = returnedDetails
                self.coinDetailSubscription?.cancel() // because it is called once and doesn't do anything after that so we cancel it . if it was going to be called several times during a minute we would'nt do that.
            }
        //      .store(in: &cancellables)
        
    }
}
