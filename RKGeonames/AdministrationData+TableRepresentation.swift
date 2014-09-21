//
//  AdministrationData+TableRepresentation.swift
//  RKGeonames
//
//  Created by Stefan Buretea on 9/20/14.
//  Copyright (c) 2014 Stefan Burettea. All rights reserved.
//

import Foundation

extension AdministrationData {
    
    func tr_tableRepresentation() -> NSDictionary {
        
        return ["titles" : ["Capital", "Surface", "CurrentTime", "TimeZone", "Sunrise", "Sunset"],
                "values" : [self.capitalCity, self.surface, self.currentTime, self.timeZone, self.sunrise, self.sunset]];
    }
}