//
//  CoinDataService.swift
//  CryptoTracker
//
//  Created by Maryam Kaveh on 11/25/1401 AP.
//


// Services are usually 3rd party and utillities are usually internal stuff
import Foundation
import Combine

class CoinDataService {
  @Published var allCoins: [CoinModel] = []
  //var cancellables = Set<AnyCancellable>() // It's hard to cancel this specific publisher if we want to because of Set, so we can use single Cancellable instead to cancel it any time we want.
  var coinSubscription: AnyCancellable? // Whenever we want to cancel the publisher we can use this way
  
  init() {
    getCoins()
    
  }
  
    func getCoins() { // we made it public to call it from refreshable too
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h") else {return}
        
        //Because this part of building a publisher is common in every call to every data service, we extract it out to another file(networkingManager) to clean the code
          coinSubscription = NetworkingManager.download(url: url)
          .decode(type: [CoinModel].self, decoder: JSONDecoder())
          .sink { (completion) in
            switch completion {
            case .failure(let error):
              print(error.localizedDescription)
                print(error)
            case .finished: // default
              break
            }
          } receiveValue: { [weak self] (returnedCoins) in
              print("Get coins successfully!")
            guard let self = self else {return} // or self?.allCoins = returnedCoins
            self.allCoins = returnedCoins
            self.coinSubscription?.cancel() // because it is called once and doesn't do anything after that so we cancel it . if it was going to be called several times during a minute we would'nt do that.
          }
    //      .store(in: &cancellables)

  }
}
