//
//  CoinRowView.swift
//  CryptoTracker
//
//  Created by Maryam Kaveh on 11/24/1401 AP.
//

import SwiftUI

struct CoinRowView: View {
  let coin: CoinModel
  let showHoldingsColumn: Bool
  private let fileManager = LocalFileManager.instance
  private let folderName = "coin_images"
  
  @State private var image: UIImage?
  
    var body: some View {
      HStack(spacing: 0) {
        // Put everything in 3 columns
        leftColumn
        Spacer()
        if showHoldingsColumn {
          centerColumn
        }
        Spacer()
        rightColumn
      }
      .font(.subheadline)
        // we add background just to be able to click on  the whole Color because the spacer between the items can't be clicked
      .background(
        Color.theme.background.opacity(0.001)
      )
    }
}

struct CoinRowView_Previews: PreviewProvider {
    static var previews: some View {
      CoinRowView(coin: CoinModel.sample, showHoldingsColumn: true)
        .previewLayout(.sizeThatFits)
    }
}

// To make our body nice and neat we divide it to 3 columns
extension CoinRowView {
  
  private var leftColumn: some View {
    HStack(spacing: 5) {
      Text("\(coin.rank)")
        .font(.body)
//        .fontWeight(.bold)
        .foregroundColor(Color.theme.secondaryText)
        .frame(minWidth: 15)
      //
//        AsyncImage(url: URL(string: coin.image)) { image in
//          image
//            .resizable()
//            .scaledToFit()
//        } placeholder: {
//          ProgressView()
//        }
        CoinImageView(coin: coin)
        .frame(width: 25, height: 25)
        .padding(.leading, 8)
        .padding(.trailing, 2)
      Text(coin.symbol.uppercased())
        .font(.headline.bold())
        .lineLimit(1)
//        .minimumScaleFactor(0.7)
        .foregroundColor(Color.theme.accent)
        .frame(minWidth: 40)
    }
  }
  
//  private func getCoinImage() {
//    if let savedImage = fileManager.getImage(imageName: coin.id, folderName: folderName) {
//      image = savedImage
//      print("Retrieved image from File Manager!")
//      
//    }
//  }
  private var centerColumn: some View {
    VStack(alignment: .trailing) {
      Text("\(coin.currentHoldingValue.currencyFormatter2.string(from: coin.currentHoldingValue as NSNumber) ?? "0.00")")
        .bold()
      Text((coin.currentHoldings ?? 0).asNumberString())
            .font(.caption).bold()
    }
    .foregroundColor(Color.theme.accent)
  }
  
  private var rightColumn: some View {
    VStack(alignment: .trailing, spacing: 0) {
      Text("\(coin.currentPrice.currencyFormatter6.string(from: coin.currentPrice as NSNumber) ?? "0.00")")
        .font(.system(size: 16)) .fontWeight(.bold)
        .foregroundColor(Color.theme.accent)
      Text((coin.priceChangePercentage24H?.asNumberString() ?? " ") + "%")
        .foregroundColor((coin.priceChange24H ?? 0) >= 0 ? Color.theme.green : Color.theme.red)
        .font(.caption)
        .fontWeight(.bold)
    }
    // Because we're in portrait mode we can use UIScreen width but if we were using landscape too, we should use a geometry reader
    .frame(width: UIScreen.main.bounds.width / 2.8, alignment: .trailing)
  }
}
