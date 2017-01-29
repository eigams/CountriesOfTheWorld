//
//  GEOWorldBankIndicatorRequest.swift
//  Rx
//
//  Created by Stefan Buretea on 1/16/17.
//  Copyright © 2017 Krunoslav Zaher. All rights reserved.
//

import Foundation


struct GEOWorldBankIndicatorRequest {
    private let countryCode: String
    private let indicator: String
    private let startYear: String
    private let endYear: String
    
    var url: String {
        return "http://api.worldbank.org/countries/\(countryCode)/indicators/\(indicator)?format=json&date=\(startYear):\(endYear)"
    }
    
    init(countryCode: String, indicator: String: startYear: String, endYear: String) {
        self.countryCode = countryCode
        self.indicator = indicator
        self.startYear = startYear
        self.endYear = endYear
    }
}
