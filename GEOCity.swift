//
//  GEOCity.swift
//  RKGeonames
//
//  Created by Stefan Buretea on 1/18/17.
//  Copyright © 2017 Stefan Burettea. All rights reserved.
//

import Foundation
import ObjectMapper


struct GEOCity: Mappable {
    var fcodeName: String?
    var toponymName: String?
    var countrycode: String?
    var fcl: String?
    var fclName: String?
    var name: String?
    var wikipedia: String?
    var lng: Double?
    var fcode: String?
    var geonameId: String?
    var lat: Double?
    var population: String?

    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        fcodeName   <- map["fcodeName"]
        toponymName <- map["toponymName"]
        countrycode <- map["countrycode"]
        fcl         <- map["fcl"]
        fclName     <- map["fclName"]
        name        <- map["name"]
        wikipedia   <- map["wikipedia"]
        lng         <- map["lng"]
        fcode       <- map["fcode"]
        geonameId   <- map["geonameId"]
        lat         <- map["lat"]
        population  <- map["population"]
    }
}

struct GEOCityHTTPResponse: Mappable {
    var geonames: [GEOCity]?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        geonames <- map["geonames"]
    }
}
