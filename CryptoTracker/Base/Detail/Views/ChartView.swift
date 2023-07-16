//
//  ChartView.swift
//  CryptoTracker
//
//  Created by Maryam Kaveh on 4/25/1402 AP.
//

import SwiftUI

struct ChartView: View {
    
    let data: [Double]
    
    init(coin: CoinModel) {
        data = coin.sparklineIn7D?.price ?? []
    }
    var body: some View {
        Path { path in 
            
        }
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(coin: dev.coin)
    }
}
