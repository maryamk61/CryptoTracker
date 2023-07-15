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
  
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
    }
    
    var body: some Scene {
        WindowGroup {
          NavigationView {
            HomeView()
//              .navigationBarHidden(true)
              .navigationBarBackButtonHidden(false)
          }
          .environmentObject(viewModel)
        }
      
    }
}
