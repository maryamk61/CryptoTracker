//
//  HomeView.swift
//  CryptoTracker
//
//  Created by Maryam Kaveh on 11/23/1401 AP.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var viewModel: HomeViewModel
    
    @State private var showPortfolio: Bool = false // animate right
    @State private var showPortfolioView: Bool = false // new sheet
    @State private var showSettingsView: Bool = false//new sheet
    @State private var selectedCoin: CoinModel?
    @State private var showDetailView: Bool = false
    @State private var showErrorAlert: Bool = false
    
    @ViewBuilder
    var body: some View {
        ZStack {
            // background layer
            Color.theme.background
                .ignoresSafeArea()
                .sheet(isPresented: $showPortfolioView) {
                    PortFolioView(isPresented: $showPortfolioView)
                        .environmentObject(viewModel) // it's a new environment (new sheet) so to send the homeViewModel to the sheet because we use it there
                }
                .sheet(isPresented: $showSettingsView) {
                    SettingsView(isPresented: $showSettingsView)
                }
//            ProgressView()
//                .accentColor(Color.theme.accent)
//                .scaleEffect(x: 1.5, y: 1.5, anchor: .center)
//                .offset(x: 0, y: 40)
            //content layer
            VStack {
                homeHeader
                HomeStatsView(showPortfolio: $showPortfolio)
                SearchBarView(searchText: $viewModel.searchText)
                columnTitles
                
                if !showPortfolio {
                    ZStack {
                        if viewModel.allCoins.isEmpty {
                            ProgressView()
                                .accentColor(Color.theme.accent)
                                .scaleEffect(x: 1.5, y: 1.5, anchor: .center)
                                .offset(x: 0, y: 80)
                        } else {
                            allCoinsList
                                .transition(.move(edge: .leading))
                                .refreshable {
                                    viewModel.reloadData()
                                }
                        }
                    }
                }
                if showPortfolio {
                    ZStack(alignment: .top) {
                        if viewModel.portfolioCoins.isEmpty && viewModel.searchText.isEmpty {
                            portfolioEmptyText
                        } else {
                            portfolioCoinsList
                                .refreshable {
                                    viewModel.reloadData()
                                }
                            
                            
                        }
                    }
                    .transition(.move(edge: .trailing))
                }
                Spacer(minLength: 0)
            }
        }
        .preferredColorScheme(.dark)
        // iOS 16
        .navigationDestination(isPresented: $showDetailView) {
            DetailLoadingView(coin: $selectedCoin)
                .navigationBarHidden(false)
                .navigationBarBackButtonHidden(false)
        }
        .onReceive(viewModel.$showError) { state in
            self.showErrorAlert = state
        }
        .alert(isPresented: $showErrorAlert) {
            Alert(title: Text("Error"),
                  message: Text(viewModel.errorMessage),
                  dismissButton: .cancel(Text("OK")))
        }
//        .background(
//            NavigationLink(
//                destination: DetailLoadingView(coin: $selectedCoin),
//                isActive: $showDetailView,
//                label: {
//                    EmptyView()
//                })
//        )
    }
}

private func showErrorAlert() {
    
}
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
                .navigationBarHidden(true)
                .preferredColorScheme(.dark)
            
            HomeView()
                .navigationBarHidden(true)
        }
        .environmentObject(HomeViewModel())
    }
}

extension HomeView {
    
    private var homeHeader: some View {
        HStack {
            CircleButtonView(iconName: showPortfolio ? "plus" : "info")
                .onTapGesture {
                    if showPortfolio {
                        showPortfolioView.toggle()
                    } else {
                        showSettingsView.toggle()
                    }
                }
                .animation(nil, value: UUID())
                .background {
                    CircleButtonAnimationView(animate: $showPortfolio)
                }
            Spacer()
            Text(showPortfolio ? "Show Portfolio" : "Live Prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(Color.theme.accent)
                .animation(nil, value: UUID())
            Spacer()
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: showPortfolio ? 180 : 0))
                .onTapGesture {
                    withAnimation(.spring()) {
                        showPortfolio.toggle()
                    }
                }
        }
    }
    
    private var allCoinsList: some View {
        List {
            ForEach(viewModel.allCoins) { coin in
//                NavigationLink(destination:DetailLoadingView(coin: $selectedCoin), isActive: $showDetailView) {
                CoinRowView(coin: coin, showHoldingsColumn: false)
                    .listRowInsets(.init(top: 10, leading: 3, bottom: 10, trailing: 10))
                    .onTapGesture {
                        segue(coin: coin)
                    }
                    .listRowBackground(Color.theme.background)
//              }
            }
        }
        .listStyle(.plain)
    }
    
    private var portfolioCoinsList: some View {
        List {
            ForEach(viewModel.portfolioCoins) { coin in
                CoinRowView(coin: coin, showHoldingsColumn: true)
                    .listRowInsets(.init(top: 10, leading: 3, bottom: 10, trailing: 10))
                    .onTapGesture {
                        segue(coin: coin)
                    }
                    .listRowBackground(Color.theme.background)
            }
        }
        .listStyle(.plain)
    }
    
    private func segue(coin: CoinModel) {
        selectedCoin = coin
        showDetailView.toggle()
    }
    
    private var columnTitles: some View {
        HStack {
            HStack(spacing: 3) {
                Text("Coins")
                    .font(.caption)
                Image(systemName: "chevron.down")
                    .opacity((viewModel.sortOption == .rank || viewModel.sortOption == .rankReversed) ? 1.0 : 0.0)
                    .rotationEffect(Angle(degrees: (viewModel.sortOption == .rankReversed) ? 180 : 0))
            }
            .onTapGesture {
                withAnimation(.default) {
                    viewModel.sortOption = (viewModel.sortOption == .rank) ? .rankReversed : .rank                    
                }
            }
            
            Spacer()
            if showPortfolio {
                HStack(spacing: 3) {
                    Text("Holdings")
                        .font(.caption)
                    Image(systemName: "chevron.down")
                        .opacity((viewModel.sortOption == .holdings || viewModel.sortOption == .holdingsReversed) ? 1.0 : 0.0)
                        .rotationEffect(Angle(degrees: (viewModel.sortOption == .holdings) ? 0 : 180))
                }
                .onTapGesture {
                    withAnimation(.default) {
                        viewModel.sortOption = (viewModel.sortOption == .holdings) ? .holdingsReversed : .holdings
                    }
                }
            }
            HStack(spacing: 3) {
                Text("Price")
                    .font(.caption)
                    .frame(width: UIScreen.main.bounds.width / 2.8, alignment: .trailing)
                Image(systemName: "chevron.down")
                    .opacity((viewModel.sortOption == .price || viewModel.sortOption == .priceReversed) ? 1.0 : 0.0)
                    .rotationEffect(Angle(degrees: (viewModel.sortOption == .price) ? 0 : 180))
            }
            .onTapGesture {
                withAnimation(.default) {
                    viewModel.sortOption = (viewModel.sortOption == .price) ? .priceReversed : .price
                }
            }
        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
        .padding(.horizontal)
    }
    
    private var portfolioEmptyText: some View {
        Text("You haven't added any coins to your portfolio yet!.Click the + button to get started.")
            .font(.callout)
            .foregroundColor(Color.theme.secondaryText)
            .fontWeight(.medium)
            .multilineTextAlignment(.center)
            .padding(50)
    }
}
