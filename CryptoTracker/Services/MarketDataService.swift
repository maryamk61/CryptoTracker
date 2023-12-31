//
//  MarketDataService.swift
//  CryptoTracker
//
//  Created by Maryam Kaveh on 4/11/1402 AP.
//

import Foundation
import Combine

class MarketDataService {
  @Published var marketData: MarketDataModel?
    let url = "https://api.coingecko.com/api/v3/global"
  var marketSubscription: AnyCancellable?
  init() {
    getData()
    
  }
  
    func getData() { // we made it public to call it from refreshable too
        
        //Because this part of building a publisher is common in every call to every data service, we extract it out to another file(networkingManager) to clean the code
          marketSubscription = NetworkingManager.download(url: url)
          .decode(type: GlobalData.self, decoder: JSONDecoder())
          .receive(on: DispatchQueue.main)//receive on th main thread after decoding
          .sink {(completion) in
                 switch completion {
                 case .failure(let error):
                     print(error.localizedDescription)
                 case .finished: // default
                     break
                 }
          } receiveValue: {[weak self] (returnedGlobalData) in
            guard let self = self else {return} // or self?.allCoins = returnedCoins
              self.marketData = returnedGlobalData.data
              self.marketSubscription?.cancel() // because it is called once and doesn't do anything after that so we cancel it . if it was going to be called several times during a minute we would'nt do that.
          }
  }
}
