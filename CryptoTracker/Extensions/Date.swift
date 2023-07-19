//
//  Date.swift
//  CryptoTracker
//
//  Created by Maryam Kaveh on 4/27/1402 AP.
//

import Foundation

extension Date {
    // "2021-11-10T14:24:19.604Z"
    init(coingeckoString: String) {
       let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = formatter.date(from: coingeckoString) ?? Date()
        self.init(timeInterval: 0, since: date)
    }
    
    private var shortFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
    
    func asShortDateString() -> String{
        return shortFormatter.string(from: self)
    }
}
