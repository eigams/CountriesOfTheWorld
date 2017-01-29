//
//  GEOWorldBankIndicator.swift
//  Rx
//
//  Created by Stefan Buretea on 1/16/17.
//  Copyright © 2017 Krunoslav Zaher. All rights reserved.
//

import Foundation
import ObjectMapper


struct GEOWorldBankCountry: Mappable {
    var identifier: String?
    var value: String?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        identifier  <- map["id"]
        value       <- map["value"]
    }
}

struct GEOIndicator: Mappable {
    var identifier: String?
    var value: String?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        identifier  <- map["id"]
        value       <- map["value"]
    }
}

struct GEOWorldBankIndicator: Mappable {
    var indicator: GEOIndicator?
    var country: GEOWorldBankCountry?
    var value: String?
    var decimal: String?
    var date: String?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        indicator  <- map["indicator"]
        country    <- map["country"]
        value      <- map["value"]
        decimal    <- map["decimal"]
        date       <- map["date"]
    }
}

struct GEOWorldBankIndicatorHTTPResponse: Mappable {
    var indicators: [Any]?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        indicators <- map["indicators"]
    }
}
