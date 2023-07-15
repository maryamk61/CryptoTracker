//
//  Color.swift
//  CryptoTracker
//
//  Created by Maryam Kaveh on 11/18/1401 AP.
//

import Foundation
import SwiftUI

extension Color {
  static let theme = ColorTheme()
}


struct ColorTheme {
  let accent = Color("AccentColor")
  let background = Color("BackgroundColor")
  let green = Color("GreenColor")
  let red = Color("RedColor")
  let secondaryText = Color("SecondaryTextColor")
}
