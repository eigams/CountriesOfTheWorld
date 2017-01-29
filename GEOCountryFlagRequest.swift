//
//  GEOCountryFlagRequest.swift
//  RKGeonames
//
//  Created by Stefan Buretea on 1/20/17.
//  Copyright © 2017 Stefan Burettea. All rights reserved.
//

import Foundation


struct GEOCountryFlagRequest {
    var url: String {
        if let countryCode = country.countryCode {
            return "http://www.geonames.org/flags/x/\(countryCode.lowercased()).gif"
        }
        
        return ""
    }
    
    let country: GEOCountry
    
    init(country: GEOCountry) {
        self.country = country
    }
}
