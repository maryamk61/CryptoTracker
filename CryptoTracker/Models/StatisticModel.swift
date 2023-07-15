//
//  StatisticModel.swift
//  CryptoTracker
//
//  Created by Maryam Kaveh on 3/28/1402 AP.
//

import Foundation

struct StatisticModel: Identifiable {
    let title: String
    let value: String
    let percentageChange: Double?
    let id = UUID().uuidString
    
    
    init(title:String, value: String, percentageChange: Double? = nil) {
        self.title = title
        self.value = value
        self.percentageChange = percentageChange
    }
    
   
}
