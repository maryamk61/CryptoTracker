//
//  ChartView.swift
//  CryptoTracker
//
//  Created by Maryam Kaveh on 4/25/1402 AP.
//

import SwiftUI

struct ChartView: View {
    
    private let data: [Double]
    private let maxY: Double
    private let minY: Double
    private let lineColor: Color
    private let startingDate: Date
    private let endingDate: Date
    @State private var percentage: CGFloat = 0
    
    init(coin: CoinModel) {
        data = coin.sparklineIn7D?.price ?? []
        maxY = data.max() ?? 0
        minY = data.min() ?? 0
        // 60,000 max
        // 50,000 min
        let pricechange = (data.last ?? 0 ) - (data.first ?? 0)
        lineColor = pricechange > 0 ? Color.theme.green : Color.theme.red
        endingDate = Date(coingeckoString: coin.lastUpdated ?? "")
        startingDate = endingDate.addingTimeInterval(-7*24*60*60)
    }
    
    // 300 px
    //100 price.count
    // 1 * 3 = 3
    // 2 * 3 = 6
    // 100 * 3 = 300
    // 52,000 - data point
    // 52,000 - 50,000 = 2,000 / 10,000 = 20%
    var body: some View {
        //UIScreen.main.bounds.width is not dynamic, if we want some padding
        VStack {
            chartView
                .frame(height: 200)
                .background(
                    VStack {
                        Divider()
                        Spacer()
                        Divider()
                        Spacer()
                        Divider()
                    }
                )
                .overlay(
                    chartNumbersOverlay
                        .padding(.horizontal, 5)
                    , alignment: .leading
                )
            shortDateLables
                .padding(.horizontal, 5)
        }
        .font(.caption).bold()
        .foregroundColor(Color.theme.secondaryText)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                withAnimation(.linear(duration: 1.0)) {
                    percentage = 1.0
                }
            }
        }
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(coin: dev.coin)
    }
}

extension ChartView {
    private var chartView: some View {
        GeometryReader { proxy in
                Path { path in
                    for index in data.indices {
                        let xposition = proxy.size.width / CGFloat(data.count) * CGFloat(index + 1)//index starts at 0
                        let yposition = CGFloat(1 - (data[index] - minY) / (maxY - minY)) *  proxy.size.height // 20%
                        if index == 0 {
                            path.move(to: CGPoint(x: xposition, y: yposition))
                        }
                        path.addLine(to: CGPoint(x: xposition, y: yposition))
                    }
                }
                .trim(from: 0, to: percentage)
                .stroke(lineColor, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                .shadow(color: lineColor, radius: 10, x: 0.0, y: 10)
                .shadow(color: lineColor.opacity(0.5), radius: 10, x: 0.0, y: 20)
                .shadow(color: lineColor.opacity(0.15), radius: 10, x: 0.0, y: 30)
        }
    }
    
    private var chartNumbersOverlay: some View {
        VStack {
            Text(maxY.formattedWithAbbreviations())
            Spacer()
            let price = ((maxY + minY) / 2).formattedWithAbbreviations()
            Text("\(price)")
            Spacer()
            Text(minY.formattedWithAbbreviations())
        }
    }
    
    private var shortDateLables: some View {
        HStack {
            Text(startingDate.asShortDateString())
            Spacer()
            Text(endingDate.asShortDateString())
        }
    }
}
