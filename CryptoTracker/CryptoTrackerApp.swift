//
//  CryptoTrackerApp.swift
//  CryptoTracker
//
//  Created by Maryam Kaveh on 11/18/1401 AP.
//

import SwiftUI

@main
struct CryptoTrackerApp: App {
  @StateObject private var viewModel = HomeViewModel()
    @State private var showLaunchView: Bool = true
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                NavigationView {
                    HomeView()
                    //.navigationBarHidden(true)
                        .navigationBarBackButtonHidden(false)
                }
                .environmentObject(viewModel)
                
                ZStack {
                    if showLaunchView {
                        LaunchView(showLaunchView: $showLaunchView)
                            .transition(.move(edge: .leading))
                    }
                }
                .zIndex(2.0) // always on top of the NavigationView
            }
        }
      
    }
}
