//
//  HapticManager.swift
//  CryptoTracker
//
//  Created by Maryam Kaveh on 4/18/1402 AP.
//

import Foundation
import SwiftUI

class HapticManager {
    static private let generator = UINotificationFeedbackGenerator()
    
    static func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        generator.notificationOccurred(type)
    }
}
