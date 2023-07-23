//
//  PortFolioView.swift
//  CryptoTracker
//
//  Created by Maryam Kaveh on 4/11/1402 AP.
//

import SwiftUI

struct PortFolioView: View {
//    @Environment(\.dismiss) var dismiss
    @Binding var isPresented: Bool
    @EnvironmentObject private var vm: HomeViewModel
    @State private var selectedCoin: CoinModel? // to make HomeViewModel file not more complicated we write here
    @State private var amountText: String = ""
    @State private var showCheckMark: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    SearchBarView(searchText: $vm.searchText)
                    CoinLogoHList
                    if selectedCoin != nil {
                        portfolioDetails
                    }
                }
            }
            .background(
                Color.theme.background
                    .ignoresSafeArea()
            )
            .navigationTitle("Edit Portfolio")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    XmarkButton(isPresented: $isPresented) // to reuse on other screens
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    toolbarSaveButton
                }
            }
            .onChange(of: vm.searchText) { newValue in
                if newValue == "" {
                    removeSelectedCoin()
                }
            }
        }
    }
    
    private func getCurrentValue() -> Double {
        if let quantity = Double(amountText) {
            return quantity * Double(selectedCoin?.currentPrice ?? 0)
        }
        return 0
    }
}


struct PortFolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortFolioView(isPresented: .constant(true))
            .environmentObject(dev.homeVM)
    }
}

extension PortFolioView {
    private var CoinLogoHList: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 10) {
                ForEach(vm.allCoins) { item in
                    
                    CoinLogoView(coin: item)
                        .frame(width: 70)
                        .padding(4)
                        .onTapGesture {
                            withAnimation(.easeIn) {
//                                selectedCoin = item
                                updateSelectedCoin(coin: item)
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(selectedCoin?.id == item.id ? Color.theme.green : Color.clear, lineWidth: 1)
                        )
                }
            }
            .padding(.vertical, 4)
            .padding(.leading)
        }

    }
    
    private func updateSelectedCoin(coin: CoinModel) {
        selectedCoin = coin
        if let foundedCoin = vm.portfolioCoins.first(where: {$0.id == coin.id}),
            let amount = foundedCoin.currentHoldings {
            amountText = "\(amount)"
        } else {
            amountText = ""
        }
    }
    
    private var portfolioDetails: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Current price of \(selectedCoin?.symbol.uppercased() ?? ""): ")
                Spacer()
                Text(selectedCoin?.currentPrice.asCurrencyWith6Decimals() ?? "")
                    .bold()
            }
            Divider()
            HStack {
                Text("Amount holding:")
                Spacer()
                TextField("Ex: 1.4", text: $amountText)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
                
            }
            Divider()
            HStack {
                Text("Current Value:")
                Spacer()
                Text("\(getCurrentValue().asCurrencyWith2Decimals())")
                    .bold()
            }
        }
        .animation(nil, value: UUID())
        .padding()
        .font(.headline)
    }
    
    private var toolbarSaveButton: some View {
        HStack {
            Image(systemName: "checkmark")
                .opacity(showCheckMark ? 1.0 : 0.0)
            Button {
                saveButtonPressed()
            } label: {
                Text("SAVE")
            }
            .font(.headline)
            .bold()
            .foregroundColor(Color.theme.accent)
            .opacity((selectedCoin != nil && selectedCoin?.currentHoldings != Double(amountText)) ? 1.0 : 0.0 )
        }
    }
    
    private func saveButtonPressed() {
        guard let coin = selectedCoin else {return}
        
        // save to portfolio
        vm.updatePortfolio(coin: coin, amount: Double(amountText) ?? 0)
        
        //show checkmark
        withAnimation(.easeIn) {
            showCheckMark = true
            removeSelectedCoin()
        }
        
        //hide keyboard
        UIApplication.shared.hideKeyboard()
        
        //hide checkmark
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(.easeOut) {
                showCheckMark = false
            }
        }
        
    }
    
    private func removeSelectedCoin() {
        selectedCoin = nil
        vm.searchText = ""
    }
}
