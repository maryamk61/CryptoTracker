//
//  String.swift
//  CryptoTracker
//
//  Created by Maryam Kaveh on 4/27/1402 AP.
//

import Foundation

extension String {
    
    var removeHTMLOccurances: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
    }
}
