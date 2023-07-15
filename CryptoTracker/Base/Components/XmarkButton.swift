//
//  XmarkButton.swift
//  CryptoTracker
//
//  Created by Maryam Kaveh on 4/11/1402 AP.
//

import SwiftUI

struct XmarkButton: View {
//    @Environment(\.dismiss) var dismiss
    @Binding var isPresented: Bool
    
    var body: some View {
        Button(action: {
            isPresented = false
        }, label: {
            Image(systemName: "xmark")
                .font(.headline)
        })
    }
}

struct XmarkButton_Previews: PreviewProvider {
    static var previews: some View {
        XmarkButton(isPresented: .constant(true))
    }
}
