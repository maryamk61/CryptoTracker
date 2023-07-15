//
//  CoinImageView.swift
//  CryptoTracker
//
//  Created by Maryam Kaveh on 12/17/1401 AP.
//

import SwiftUI

struct CoinImageView: View {
  @StateObject var vm: CoinImageViewmodel
  
    init(coin: CoinModel) {
       _vm = StateObject(wrappedValue: CoinImageViewmodel(coin: coin))
    }
    
    var body: some View {
      ZStack {
        if let image = vm.image {
          Image(uiImage: image)
            .resizable()
            .scaledToFit()
        } else if vm.isLoading {
          ProgressView()
        } else {
          Image(systemName: "questionmark")
            .foregroundColor(Color.theme.secondaryText)
        }
      }
    }
}

struct CoinImageView_Previews: PreviewProvider {
    static var previews: some View {
        CoinImageView(coin: CoinModel.sample)
        .previewLayout(.sizeThatFits)
    }
}
