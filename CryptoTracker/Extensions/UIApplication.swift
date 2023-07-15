//
//  UIApplication.swift
//  CryptoTracker
//
//  Created by Maryam Kaveh on 3/25/1402 AP.
//

import Foundation
import SwiftUI

extension UIApplication {
    //for supporting ios 13 and 14
    func hideKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
