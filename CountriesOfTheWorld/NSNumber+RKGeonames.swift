//
//  NSNumber+RKGeonames.swift
//  RKGeonames
//
//  Created by Stefan Buretea on 4/6/15.
//  Copyright (c) 2015 Stefan Burettea. All rights reserved.
//

import Foundation

extension NSNumber {

    private var numberFormatter: NSNumberFormatter {
        
        struct Static {
            static let instance: NSNumberFormatter = {
                let formatter = NSNumberFormatter()
                
                return formatter
                }()
        }
        
        return Static.instance
    }
    
    func numberFromStringWithStyle(source: String, style: NSNumberFormatterStyle) -> NSNumber {
        
        self.numberFormatter.numberStyle = style
        
        return self.numberFormatter.numberFromString(source)!
    }
    
}