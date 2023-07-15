//
//  SearchBarView.swift
//  CryptoTracker
//
//  Created by Maryam Kaveh on 3/25/1402 AP.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String // for more usability for other pages we use @bindig instead of @state
    
    var body: some View {
        
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(
                    searchText.isEmpty ? Color.theme.secondaryText :
                        Color.theme.accent
                )
            TextField("Search by name or symbol...", text: $searchText)
                .foregroundColor(Color.theme.accent)
                .autocorrectionDisabled()
                .overlay (
                    Image(systemName: "x.circle.fill")
                        .padding() // to make the click area bigger
                        .foregroundColor(Color.theme.accent)
                        .opacity(searchText.isEmpty ? 0 : 1)
                        .offset(x: 10)
                        .onTapGesture {
                            searchText = ""
                            //for supporting ios 13 and 14
                            UIApplication.shared.hideKeyboard()
                        }
                    , alignment: .trailing
                )
        }
        
        .font(.headline)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 25 )
                .fill(Color.theme.background)
                .shadow(color: Color.theme.accent.opacity(0.2),
                        radius: 10)
        )
        .padding()
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SearchBarView(searchText: .constant(""))
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.light)
            SearchBarView(searchText: .constant(""))
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}
