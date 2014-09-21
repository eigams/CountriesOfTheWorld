//
//  EconomyData.swift
//  RKGeonames
//
//  Created by Stefan Buretea on 9/21/14.
//  Copyright (c) 2014 Stefan Burettea. All rights reserved.
//

import Foundation

class EconomyData : NSObject {
    
    let currency: NSString
    let gdp: NSString
    let gdppc: NSString
    let gnipc: NSString
    
    init(currency: NSString, gdp: NSString, gdppc: NSString, gnipc: NSString) {
        
        self.currency = currency
        self.gdp = gdp
        self.gdppc = gdppc
        self.gnipc = gnipc
    }
    
    class func data() -> EconomyData {
        
        return EconomyData(currency: "" as NSString!, gdp: "" as NSString!, gdppc: "" as NSString!, gnipc: "" as NSString!)
    }
    
}