//
//  CoinModel.swift
//  CryptoTracker
//
//  Created by Maryam Kaveh on 11/24/1401 AP.
//

import Foundation

// CoinGecko API info
/* URL:
 https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h
 
 JSON Response:
 {
     "id": "bitcoin",
     "symbol": "btc",
     "name": "Bitcoin",
     "image":"https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579",
     "current_price": 21857,
     "market_cap": 421746360569,
     "market_cap_rank": 1,
     "fully_diluted_valuation": 459146154295,
     "total_volume": 29111657534,
     "high_24h": 22101,
     "low_24h": 21650,
     "price_change_24h": 26.54,
     "price_change_percentage_24h": 0.12158,
     "market_cap_change_24h": 915658989,
     "market_cap_change_percentage_24h": 0.21758,
     "circulating_supply": 19289443,
     "total_supply": 21000000,
     "max_supply": 21000000,
     "ath": 69045,
     "ath_change_percentage": -68.28207,
     "ath_date": "2021-11-10T14:24:11.849Z",
     "atl": 67.81,
     "atl_change_percentage": 32195.965,
     "atl_date": "2013-07-06T00:00:00.000Z",
     "roi": null,
     "last_updated": "2023-02-13T08:11:52.400Z",
     "sparkline_in_7d": {
       "price": [
         22742.644241851332,
         22798.70464072346,
         22880.52641622407,
         22855.677504026055
       ]
     },
     "price_change_percentage_24h_in_currency": 0.12157774934971166
   }
 */

// made by https://app.quicktype.io/ so it's easier
struct CoinModel: Identifiable, Codable {
    let id, symbol, name: String
    let image: String
    let currentPrice: Double
    let marketCap, marketCapRank, fullyDilutedValuation: Double?
    let totalVolume, high24H, low24H: Double?
    let priceChange24H, priceChangePercentage24H: Double?
    let marketCapChange24H: Double?
    let marketCapChangePercentage24H: Double?
    let circulatingSupply, totalSupply, maxSupply, ath: Double?
    let athChangePercentage: Double?
    let athDate: String?
    let atl, atlChangePercentage: Double?
    let atlDate: String?
    let lastUpdated: String?
    let sparklineIn7D: SparklineIn7D?
    let priceChangePercentage24HInCurrency: Double?
    let currentHoldings: Double? // not existed in json, we added so it must be optional and we update it ourselves(current count of this coin for the user)
  
    enum CodingKeys: String, CodingKey {
      case id, symbol, name, image
      case currentPrice = "current_price"
      case marketCap = "market_cap"
      case marketCapRank = "market_cap_rank"
      case fullyDilutedValuation = "fully_diluted_valuation"
      case totalVolume = "total_volume"
      case high24H = "high_24h"
      case low24H = "low_24h"
      case priceChange24H = "price_change_24h"
      case priceChangePercentage24H = "price_change_percentage_24h"
      case marketCapChange24H = "market_cap_change_24h"
      case marketCapChangePercentage24H = "market_cap_change_percentage_24h"
      case circulatingSupply = "circulating_supply"
      case totalSupply = "total_supply"
      case maxSupply = "max_supply"
      case ath
      case athChangePercentage = "ath_change_percentage"
      case athDate = "ath_date"
      case atl
      case atlChangePercentage = "atl_change_percentage"
      case atlDate = "atl_date"
      case lastUpdated = "last_updated"
      case sparklineIn7D = "sparkline_in_7d"
      case priceChangePercentage24HInCurrency = "price_change_percentage_24h_in_currency"
      case currentHoldings
    }
  
  func updateHoldings(amount: Double) -> CoinModel {
    return CoinModel(id: id, symbol: symbol, name: name, image: image, currentPrice: currentPrice, marketCap: marketCap, marketCapRank: marketCapRank, fullyDilutedValuation: fullyDilutedValuation, totalVolume: totalVolume, high24H: high24H, low24H: low24H, priceChange24H: priceChange24H, priceChangePercentage24H: priceChangePercentage24H, marketCapChange24H: marketCapChange24H, marketCapChangePercentage24H: marketCapChangePercentage24H, circulatingSupply: circulatingSupply, totalSupply: totalSupply, maxSupply: maxSupply, ath: ath, athChangePercentage: athChangePercentage, athDate: athDate, atl: atl, atlChangePercentage: atlChangePercentage, atlDate: atlDate, lastUpdated: lastUpdated, sparklineIn7D: sparklineIn7D, priceChangePercentage24HInCurrency: priceChangePercentage24HInCurrency, currentHoldings: amount)
  }
  
  var currentHoldingValue: Double {
    return (currentHoldings ?? 0) * currentPrice
  }
  
  var rank: Int {
    return Int(marketCapRank ?? 0)
  }
  
    static var sample = CoinModel(id: "bitcoin", symbol: "btc", name: "Bitcoin", image: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579", currentPrice: 21857.1234, marketCap: 421746360569, marketCapRank: 1, fullyDilutedValuation: 459146154295, totalVolume: 29111657534, high24H: 22106.2333, low24H: 21650.5640, priceChange24H: 26.54, priceChangePercentage24H: 0.12158, marketCapChange24H: -0.21758, marketCapChangePercentage24H: -0.34, circulatingSupply: 19289443, totalSupply: 21000000, maxSupply: 21000000, ath: 69045, athChangePercentage: -6.28207, athDate: "2021-11-10T14:24:19.604Z", atl: 67.81, atlChangePercentage: 3.965, atlDate: "2015-10-20T00:00:00.000Z", lastUpdated: "2023-07-18T09:11:52.400Z", sparklineIn7D: SparklineIn7D(price: [
    22742.644241851332,
    22798.70464072346,
    22880.52641622407,
    22855.677504026055,
    22831.796965615384,
    22837.966426321556,
    22818.893537877313,
    22876.74594902388,
    22825.38689366925,
    22816.21383631307,
    22942.673526625666,
    22994.901677476406,
    23058.911842754183,
    22997.90906926124,
    23027.720853372055,
    23001.37194748845,
    22930.756764936992,
    22906.739698385736,
    22786.483006387727,
    22833.24912856354,
    22908.170700100138,
    22888.793807740138,
    22902.105986980114,
    22899.763156102596,
    22947.83365997831,
    22961.74105232749,
    22920.49880546742,
    22894.97920502659,
    23102.669977948826,
    23020.075316978342,
    23014.999215430624,
    23042.76293413535,
    23016.93718851803,
    23025.713898851514,
    22931.55285446975,
    23010.3301592181,
    23610.185929260544,
    22959.40588397159,
    23131.81455887355,
    23199.974887607776,
    23207.933064926743,
    23205.90053334457,
    23259.39942465226,
    23282.325457981762,
    23310.172648744316,
    23293.08625731691,
    23265.70299300269,
    23269.70693095379,
    23256.444021133044,
    23208.155194384657,
    23218.836728811897,
    23207.52290863466,
    23211.875881106138,
    23167.647299046766,
    23164.578702931558,
    23125.045055968312,
    23118.582072783975,
    23027.711189004673,
    22905.275246487745,
    22871.10332505254,
    23017.385722744664,
    22922.27241030744,
    22876.692471410483,
    22890.82515668799,
    22972.59838643113,
    22957.553732646666,
    22947.50782856846,
    23009.06132473836,
    22959.306934864217,
    22877.145510333332,
    22526.668440964368,
    22577.84565069176,
    22606.428257540603,
    22711.288391741058,
    22676.274501074193,
    22744.787092216447,
    22788.35747603418,
    22719.384939248055,
    22680.106300981526,
    22722.654509135424,
    22778.415158578773,
    22743.85661969,
    22660.20991903482,
    22553.628480160485,
    22566.571699592154,
    22521.83527785406,
    21986.702456169925,
    22037.521045261594,
    21864.036970068137,
    21844.198227891193,
    21809.95394073028,
    21823.361796157773,
    21893.544868017332,
    21958.603365979103,
    21877.198202116746,
    21808.63953281911,
    21819.977699772928,
    21955.609140971254,
    21925.601781942183,
    21888.520235687192,
    21832.258293046565,
    21860.334630136946,
    21772.805172533266,
    21758.88215682467,
    21794.946212233364,
    21828.3489986006,
    21615.707321562975,
    21689.715252271788,
    21704.843198700888,
    21702.189591927166,
    21801.3249922097,
    21735.221421311657,
    21499.66173221349,
    21518.879040935193,
    21643.699159129977,
    21719.05888786595,
    21668.325329180243,
    21677.75755086969,
    21682.010362551075,
    21705.259912021633,
    21707.98644374092,
    21683.685297219195,
    21696.951518290687,
    21706.47622551688,
    21701.63551500821,
    21686.167443862698,
    21704.537718638298,
    21705.533869309656,
    21765.11263742004,
    21761.93829859602,
    21739.749451531054,
    21713.467386147055,
    21726.142061316492,
    21808.204091155432,
    21681.233181761287,
    21687.81279680176,
    21836.91608768026,
    21851.016108172767,
    21889.579130643924,
    21826.662609068593,
    21821.10796574619,
    21838.463457010097,
    21809.13173942368,
    21792.24798693111,
    21811.12211585143,
    21835.415417641794,
    21814.921620263507,
    21821.4813325036,
    21880.58949439597,
    21989.567210990535,
    21903.321279830652,
    21848.458638531938,
    21819.220022498153,
    21939.759847092064,
    21936.66871273142,
    22077.091346794103,
    21994.15669372547,
    21989.378177544804,
    22011.581578213678,
    22067.78668067873,
    21798.017645084452,
    21829.311445993622,
    21779.87440384417,
    21751.26632634168,
    21728.45989523373,
    21753.441139786308,
    21820.126221060054,
    21861.307807318623
  ]),
  priceChangePercentage24HInCurrency: 0.1166, currentHoldings: 0.10325)
}

struct SparklineIn7D: Codable {
    let price: [Double]?
}

