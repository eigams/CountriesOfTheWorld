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
    struct Coordinates {
        var south: Double
        var north: Double
        var west: Double
        var east: Double
    }
    
    var continent: String?
    var capitalCity: String
    var languages: String
    var geonameId: Int
    var south: Double
    var isoAlpha3: String
    var north: Double
    var fipsCode: String
    var population: String
    var east: Double
    var isoNumeric: String
    var areaInSqKm: String
    var countryCode: String
    var west: Double
    var countryName: String
    var continentName: String
    var currencyCode: String
    var coordinates: Coordinates
    
    init?(map: Map) {}

    mutating func mapping(map: Map) {
        continent           <- map["continent"]
        capitalCity         <- map["capital"]
        languages           <- map["languages"]
        geonameId           <- map["geonameId"]
        coordinates.south   <- map["south"]
        isoAlpha3           <- map["isoAlpha3"]
        coordinates.north   <- map["north"]
        fipsCode            <- map["fipsCode"]
        population          <- map["population"]
        coordinates.east    <- map["east"]
        isoNumeric          <- map["isoNumeric"]
        areaInSqKm          <- map["areaInSqKm"]
        countryCode         <- map["countryCode"]
        coordinates.west    <- map["west"]
        countryName         <- map["countryName"]
        continentName       <- map["continentName"]
        currencyCode        <- map["currencyCode"]
    }
}
