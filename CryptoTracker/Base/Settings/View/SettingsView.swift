//
//  SettingsView.swift
//  CryptoTracker
//
//  Created by Maryam Kaveh on 4/28/1402 AP.
//

import SwiftUI

struct SettingsView: View {
    @Binding var isPresented: Bool
    // we could use viewModel
    let defaultUrl = URL(string: "https://www.google.com")!
    let youtubeUrl = URL(string: "https://www.youtube.com/@maryamMeditations")!
    let InstaUrl = URL(string: "https://www.instagram.com/mindful_life_with_meditation")!
    let coinGeckoUrl = URL(string: "https://coingecko.com")!
    let personalUrl = URL(string: "https://shows.acast.com/mindful-life-with-meditation")!
    
    var body: some View {
        NavigationView {
            List {
                firstSection
                secondSection
                ThirdSection
                lastSection
            }
            .foregroundColor(Color.blue)
            .listStyle(.grouped)
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    XmarkButton(isPresented: $isPresented)
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(isPresented: .constant(true))
    }
}

extension SettingsView {
    private var firstSection: some View {
        Section {
            VStack(alignment: .leading) {
                Image("logo")
                    .resizable()
                    .frame(width: 100 ,height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("This app was made by Maryam.It uses MVVm architecture, Combine and CoreData!")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
            }
            .padding(.vertical)
            Link(destination: youtubeUrl) {
                Text("Subscribe on Youtube! 🤩")
            }
            Link(destination: InstaUrl) {
                Text("Follow me on Instagram 🥳")
            }
            
        } header: {
            Text("Maryam Apps")
        }
    }
    private var secondSection: some View {
        Section {
            VStack(alignment: .leading) {
                Image("coingecko")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("The cryptocurrency data that is used in this app comes from a free API from CoinGecko! Prices may be slightly delayed.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
            }
            .padding(.vertical)
            Link(destination: coinGeckoUrl) {
                Text("Visit CoinGecko 🦎")
            }
            
        } header: {
            Text("CoinGecko")
        }
    }
    private var ThirdSection: some View {
        Section {
            VStack(alignment: .leading) {
                Image("profile")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("This app was developed by Maryam Kaveh.It uses SwiftUI and is written 100% in Swift.The project benefits from multi-threading, publishers/subscribers and data persisteance.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
            }
            .padding(.vertical)
            Link(destination: personalUrl) {
                Text("Visit Website")
            }
            
        } header: {
            Text("Developer")
        }
    }
    private var lastSection: some View {
        Section {
            Link(destination: defaultUrl) {
                Text("Terms of Service")
            }
            Link(destination: defaultUrl) {
                Text("Privacy Policy")
            }
            Link(destination: defaultUrl) {
                Text("Company Website")
            }
            Link(destination: defaultUrl) {
                Text("Learn More")
            }
            
        } header: {
            Text("Application")
        }
    }
}
