//
//  DetailView.swift
//  CryptoTracker
//
//  Created by Maryam Kaveh on 4/20/1402 AP.
//

import SwiftUI

struct DetailLoadingView: View {
    @Binding var coin: CoinModel?
    
    var body: some View {
        ZStack {
            if let coin = coin {
                DetailView(coin: coin)
            }
        }
    }
    
}
struct DetailView: View {
    @StateObject var vm: CoinDetailViewModel
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
//    let coin: CoinModel
    
    init(coin: CoinModel) {
//        self.coin = coin
        self._vm = StateObject(wrappedValue: CoinDetailViewModel(coin: coin))
        
    }
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("")
                    .frame(height: 150)
                overviewTitle
                Divider()
                LazyVGrid(columns: columns,
                          alignment: .leading,
                          spacing: 30,
                          pinnedViews: []) {
                    ForEach(vm.overviewStatistics) { stat in
                        StatisticView(stat: stat)
                    }
                }
                additionalTitle
                Divider()
                LazyVGrid(columns: columns,
                          alignment: .leading,
                          spacing: 30,
                          pinnedViews: []) {
                    ForEach(vm.additionalStatistics) {stat in
                        StatisticView(stat: stat)
                    }
                }
            }
            .padding()
        }
        .navigationTitle(vm.coin.name)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailView(coin: dev.coin)
        }
            
    }
}


extension DetailView {
    private var overviewTitle: some View {
        Text("Overview")
            .font(.title).bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity,alignment: .leading)
    }
    
    private var additionalTitle: some View {
        Text("Additional Details")
            .font(.title).bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity,alignment: .leading)
    }
}
