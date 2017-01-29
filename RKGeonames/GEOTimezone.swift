//
//  GEOTimezone.swift
//  RKGeonames
//
//  Created by Stefan Buretea on 1/18/17.
//  Copyright © 2017 Stefan Burettea. All rights reserved.
//

import Foundation
import ObjectMapper


struct GEOTimezone: Mappable {
    var time: String?
    var countryName: String?
    var sunset: String?
    var rawOffset: Int?
    var dstOffset: Int?
    var countryCode: String?
    var gmtOffset: Int?
    var lng: Double?
    var sunrise: String?
    var timezoneId: String?
    var lat: Double?

    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        time        <- map["time"]
        countryName <- map["countryName"]
        sunset      <- map["sunset"]
        rawOffset   <- map["rawOffset"]
        dstOffset   <- map["dstOffset"]
        countryCode <- map["countryCode"]
        gmtOffset   <- map["gmtOffset"]
        lng         <- map["lng"]
        lat         <- map["lat"]
        sunrise     <- map["sunrise"]
        timezoneId  <- map["timezoneId"]
    }
    
    var asString: String {
        guard let gmtOffset = gmtOffset else { return "" }
        
        return gmtOffset >= 0 ? "GMT+\(gmtOffset)" : "GMT\(gmtOffset)"
    }
}
