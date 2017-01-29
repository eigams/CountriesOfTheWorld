//
//  NSNumber+RKGeonames.swift
//  RKGeonames
//
//  Created by Stefan Buretea on 4/6/15.
//  Copyright (c) 2015 Stefan Burettea. All rights reserved.
//

import Foundation

extension NSNumber {

    fileprivate var numberFormatter: NumberFormatter {
        
        struct Static {
            static let instance: NumberFormatter = {
                let formatter = NumberFormatter()
                
                return formatter
                }()
        }
        
        return Static.instance
    }
    
    func numberFromStringWithStyle(_ source: String, style: NumberFormatter.Style) -> NSNumber {
        self.numberFormatter.numberStyle = style
        
        return self.numberFormatter.number(from: source) ?? NSNumber()
    }
    
}
