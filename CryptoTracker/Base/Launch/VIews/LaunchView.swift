//
//  LaunchView.swift
//  CryptoTracker
//
//  Created by Maryam Kaveh on 4/28/1402 AP.
//

import SwiftUI

struct LaunchView: View {
    // convert to array to animate letters individually
    @State private var loadingText: [String] = "Loading your portfolio...".map { String($0) }
    @State private var showText: Bool = false
    let timer = Timer.publish(every: 0.07, on: .main, in: .common).autoconnect()
    @State private var counter: Int = 0
    @State private var loops = 0
    @Binding var showLaunchView: Bool// make it @Binding to bind it to the rest of the app
    
    var body: some View {
        ZStack {
            Color.launch.background
                .ignoresSafeArea()
            Image("logo-transparent")
                .resizable()
                .frame(width: 100, height: 100)
            ZStack {
                if showText {
                    HStack(spacing: 0) {
                        ForEach(loadingText.indices) { index in
                            Text(loadingText[index])
                                .font(.headline)
                                .fontWeight(.heavy)
                                .foregroundColor(Color.launch.accent)
                                .offset(y: counter == index ? -10 : 0)
                        }
                    }
                    .transition(.scale.animation(.easeOut))
                }
                
            }
            .offset(y: 70)
        }
        .onAppear {
            showText.toggle()
        }
        .onReceive(timer) { _ in
            withAnimation(.spring()) {
                if counter == (loadingText.count - 1) {
                    counter = 0
                    loops += 1
                    if loops == 2 {
                      showLaunchView = false
                    }
                } else {
                    counter += 1
                }
            }
        }
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView(showLaunchView: .constant(true))
    }
}
