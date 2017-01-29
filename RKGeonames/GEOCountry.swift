//
//  GEOCountry.swift
//  RKGeonames
//
//  Created by Stefan Buretea on 1/16/17.
//  Copyright © 2017 Stefan Burettea. All rights reserved.
//

import Foundation
import ObjectMapper

struct GEOCountry: Mappable {
    
    var continent: String?
    var capitalCity: String?
    var languages: String?
    var geonameId: Int?
    var isoAlpha3: String?
    var fipsCode: String?
    var population: String?
    var isoNumeric: String?
    var areaInSqKm: String?
    var countryCode: String?
    var countryName: String?
    var continentName: String?
    var currencyCode: String?
    var south: Double?
    var north: Double?
    var west: Double?
    var east: Double?

    
    init?(map: Map) {}

    mutating func mapping(map: Map) {
        continent           <- map["continent"]
        capitalCity         <- map["capital"]
        languages           <- map["languages"]
        geonameId           <- map["geonameId"]
        south               <- map["south"]
        isoAlpha3           <- map["isoAlpha3"]
        north               <- map["north"]
        fipsCode            <- map["fipsCode"]
        population          <- map["population"]
        east                <- map["east"]
        isoNumeric          <- map["isoNumeric"]
        areaInSqKm          <- map["areaInSqKm"]
        countryCode         <- map["countryCode"]
        west                <- map["west"]
        countryName         <- map["countryName"]
        continentName       <- map["continentName"]
        currencyCode        <- map["currencyCode"]
    }
    
    var surfaceArea: String {
        guard let areaInSqKm = areaInSqKm, let floatAreaInSqKm = Float(areaInSqKm) else { return "" }
        
        return NumberFormatter.localizedString(from: NSNumber(value: floatAreaInSqKm), number: .decimal)
    }
}

struct GEOCountryHTTPResponse: Mappable {
    var geonames: [GEOCountry]?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        geonames <- map["geonames"]
    }
}
