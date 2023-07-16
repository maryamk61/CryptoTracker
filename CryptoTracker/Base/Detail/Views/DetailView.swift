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
                overviewGrid
                additionalTitle
                Divider()
                additionalGrid
            }
            .padding()
        }
        .navigationTitle(vm.coin.name)
        .toolbar {
            ToolbarItem(placement:.navigationBarTrailing, content: {
                navigationbarTrailingItems
            })
        }
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
    private var navigationbarTrailingItems: some View {
        HStack {
            Text(vm.coin.symbol.uppercased())
                .font(.headline)
            .foregroundColor(Color.theme.secondaryText)
            CoinImageView(coin: vm.coin)
                .frame(width: 24, height: 25)
        }
    }
    
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
    
    private var overviewGrid: some View {
        LazyVGrid(columns: columns,
                  alignment: .leading,
                  spacing: 30,
                  pinnedViews: []) {
            ForEach(vm.overviewStatistics) { stat in
                StatisticView(stat: stat)
            }
        }
    }
    
    private var additionalGrid: some View {
        LazyVGrid(columns: columns,
                  alignment: .leading,
                  spacing: 30,
                  pinnedViews: []) {
            ForEach(vm.additionalStatistics) {stat in
                StatisticView(stat: stat)
            }
        }
    }
}
