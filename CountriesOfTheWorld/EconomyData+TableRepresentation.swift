//
//  EconomyData+TableRepresentation.swift
//  RKGeonames
//
//  Created by Stefan Buretea on 9/21/14.
//  Copyright (c) 2014 Stefan Burettea. All rights reserved.
//

import Foundation

extension EconomyData {
    
    func tr_tableRepresentation () -> NSDictionary {
        
        return ["titles": ["CURRENCY", "GDP", "GDP per Capita", "GNI per Capita"],
                "values": [self.currency, self.gdp, self.gdppc, self.gnipc]]
    }
    
}