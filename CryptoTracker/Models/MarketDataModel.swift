//
//  MarketDataModel.swift
//  CryptoTracker
//
//  Created by Maryam Kaveh on 4/11/1402 AP.
//

import Foundation

// JSON data
/*
 URL: https://api.coingecko.com/api/v3/global
 JSON response :
    {
     "data": {
     "active_cryptocurrencies": 9882,
     "upcoming_icos": 0,
     "ongoing_icos": 49,
     "ended_icos": 3376,
     "markets": 767,
     "total_market_cap": {
     "btc": 40554907.27083555,
     "eth": 645971596.3838288,
     "ltc": 11129732018.91881,
     "bch": 4288273196.1136646,
     "bnb": 5039489524.494678,
     "eos": 1640193073008.2314,
     "xrp": 2566654116779.8506,
     "xlm": 11721155819635.52,
     "link": 192912754197.7731,
     "dot": 234414476192.6607,
     "yfi": 188155039.55314174,
     "usd": 1237144568800.495,
     "aed": 4544062929818.443,
     "ars": 317329651640189.94,
     "aud": 1856768426084.2192,
     "bdt": 133841780466044.89,
     "bhd": 465932150357.0719,
     "bmd": 1237144568800.495,
     "brl": 5925675055640.617,
     "cad": 1638734067278.8203,
     "chf": 1106921494343.9863,
     "clp": 991534257556529.6,
     "cny": 8973875558708.125,
     "czk": 26939565272372.008,
     "dkk": 8442831252550.54,
     "eur": 1132656575664.1714,
     "gbp": 973631538501.4194,
     "hkd": 9695068985090.4,
     "huf": 422732299159126.8,
     "idr": 18607025458130050,
     "ils": 4589014577725.78,
     "inr": 101564927332098.33,
     "jpy": 178563172102581.38,
     "krw": 1628454352224839.2,
     "kwd": 379993902885.34656,
     "lkr": 381082598765903.06,
     "mmk": 2598160736584166,
     "mxn": 21185234739510.28,
     "myr": 5774372274876.3125,
     "ngn": 940563901321950.6,
     "nok": 13377213293825.518,
     "nzd": 2021116896326.5222,
     "php": 68381927658734.086,
     "pkr": 354441918961341.25,
     "pln": 5027849550592.447,
     "rub": 109890612128284.69,
     "sar": 4640290508668.892,
     "sek": 13353614761175.66,
     "sgd": 1672866885932.026,
     "thb": 43578385270238.695,
     "try": 32228976876278.527,
     "twd": 38551033051762.805,
     "uah": 45693390305036.086,
     "vef": 123875285673.99355,
     "vnd": 29171868932315628,
     "zar": 23283499971147.195,
     "xdr": 927904200949.4138,
     "xag": 54329847054.04948,
     "xau": 644502834.5623065,
     "bits": 40554907270835.55,
     "sats": 4055490727083555
     },
     "total_volume": {
     "btc": 959071.3024057952,
     "eth": 15276395.927220305,
     "ltc": 263203821.7108226,
     "bch": 101412135.69550493,
     "bnb": 119177433.92778552,
     "eos": 38788452806.01127,
     "xrp": 60698062756.402176,
     "xlm": 277190232554.74695,
     "link": 4562138070.827239,
     "dot": 5543600321.496566,
     "yfi": 4449624.249744406,
     "usd": 29256875005.038105,
     "aed": 107461233315.3802,
     "ars": 7504437385544.143,
     "aud": 43910180851.31135,
     "bdt": 3165185654368.173,
     "bhd": 11018695007.522406,
     "bmd": 29256875005.038105,
     "brl": 140134579899.13168,
     "cad": 38753949200.42344,
     "chf": 26177267085.132797,
     "clp": 23448507610287.816,
     "cny": 212220594224.04428,
     "czk": 637086007359.7065,
     "dkk": 199662080628.13232,
     "eur": 26785868598.98753,
     "gbp": 23025131372.08995,
     "hkd": 229275889508.2319,
     "huf": 9997074189221.465,
     "idr": 440032177138273.75,
     "ils": 108524281868.68758,
     "inr": 2401879666118.6055,
     "jpy": 4222788943553.7734,
     "krw": 38510847184695.94,
     "kwd": 8986366185.297457,
     "lkr": 9012112440100.018,
     "mmk": 61443153718843.1,
     "mxn": 501003504648.77313,
     "myr": 136556464086.01541,
     "ngn": 22243124360080.277,
     "nok": 316353858007.60156,
     "nzd": 47796810411.35567,
     "php": 1617144479771.6033,
     "pkr": 8382094688943.403,
     "pln": 118902163542.97539,
     "rub": 2598771383995.638,
     "sar": 109736891567.02226,
     "sek": 315795783116.88074,
     "sgd": 39561146381.81245,
     "thb": 1030572661373.7183,
     "try": 762173776443.7471,
     "twd": 911682259094.4926,
     "uah": 1080589805286.082,
     "vef": 2929490894.2544646,
     "vnd": 689877112618797.5,
     "zar": 550624773785.4429,
     "xdr": 21943738758.15369,
     "xag": 1284830879.42125,
     "xau": 15241661.602624666,
     "bits": 959071302405.7952,
     "sats": 95907130240579.52
     },
     "market_cap_percentage": {
     "btc": 47.87977906181498,
     "eth": 18.606198667062323,
     "usdt": 6.735850084864979,
     "bnb": 3.0912097532295038,
     "usdc": 2.2144490586298002,
     "xrp": 2.0363251831175067,
     "steth": 1.1652166451969768,
     "ada": 0.8192305979069889,
     "doge": 0.7615944246321213,
     "ltc": 0.6557110480549286
     },
     "market_cap_change_percentage_24h_usd": 0.45128308097846087,
     "updated_at": 1688284145
     }
 }
 
 */

struct GlobalData: Codable {
    let data: MarketDataModel?
}

struct MarketDataModel: Codable {
    let totalMarketCap, totalVolume, marketCapPercentage: [String: Double]
    let marketCapChangePercentage24HUsd: Double
    
    enum CodingKeys: String, CodingKey {
        case totalMarketCap = "total_market_cap"
        case totalVolume = "total_volume"
        case marketCapPercentage = "market_cap_percentage"
        case marketCapChangePercentage24HUsd = "market_cap_change_percentage_24h_usd"
    }
    // we want to use total market cap in usd for this app so the rest is useless for us.
    var marketCap: String {
//        if let item = totalMarketCap.first(where: { (key,value) -> Bool in
//            return key == "usd"
//        }) {
        if let item = totalMarketCap.first(where: { $0.key == "usd" }) {
            return "$" + item.value.formattedWithAbbreviations()
        } else {
            return ""
        }
    }
    
    var volume: String {
        if let item = totalVolume.first(where: { $0.key == "usd" }) {
            return "$" + item.value.formattedWithAbbreviations()
        } else {
            return ""
        }
    }
    
    var btcDominance: String {
        if let item = marketCapPercentage.first(where: { $0.key == "btc"}) {
            return item.value.asPercentString()
        } else {
            return ""
        }
    }
}

