//
//  DemographicDataClient.swift
//  RKGeonames
//
//  Created by Stefan Buretea on 9/24/14.
//  Copyright (c) 2014 Stefan Burettea. All rights reserved.
//

import Foundation

class RKGDemographicDataClient: NSObject {
    
    class var TOTAL_POPULATION_INDICATOR_STRING: NSString {
        return "SP.POP.TOTL" as NSString
    }
    
    class var POPULATION_GROWTH_INDICATOR_STRING: NSString {
        return "SP.POP.GROW"
    }
    
    class var BIRTH_RATE_INDICATOR_STRING: NSString {
        return "SP.DYN.CBRT.IN"
    }
    
    class var DEATH_RATE_INDICATOR_STRING: NSString {
        return "SP.DYN.CDRT.IN"
    }

    class var sharedInstance: RKGDemographicDataClient {
    struct Static {
        static var onceToken: dispatch_once_t = 0
        static var instance: RKGDemographicDataClient? = nil
        }
        
        dispatch_once(&Static.onceToken) {
            Static.instance = RKGDemographicDataClient()
        }
        
        return Static.instance!
    }
    
    func getDataForCountry(country: NSString, completion: () -> Void) {
        completion()
    }
}