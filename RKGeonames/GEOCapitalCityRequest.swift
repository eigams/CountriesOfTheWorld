//
//  GEOCapitalCityRequest.swift
//  RKGeonames
//
//  Created by Stefan Buretea on 1/17/17.
//  Copyright © 2017 Stefan Burettea. All rights reserved.
//

import Foundation


struct GEOCapitalCityRequest {
    let country: GEOCountry
    
    var url: String {
        guard let north = country.north, let south = country.south, let west = country.west, let east = country.east else { return "" }
        return "http://api.geonames.org/citiesJSON?north=\(north)&south=\(south)&east=\(east)&west=\(west)&username=sbpuser".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    }
    
    init(country: GEOCountry) {
        self.country = country
    }
}
