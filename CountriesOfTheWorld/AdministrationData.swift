//
//  AdministrationData.swift
//  RKGeonames
//
//  Created by Stefan Buretea on 9/20/14.
//  Copyright (c) 2014 Stefan Burettea. All rights reserved.
//

import Foundation

class AdministrationData : NSObject {
    
    let capitalCity: NSString
    let surface: NSString
    let currentTime: NSString
    let timeZone: NSString
    let sunrise: NSString
    let sunset: NSString
    
    init(capitalCity: NSString, surface: NSString, currentTime: NSString, timeZone: NSString, sunrise: NSString, sunset: NSString) {
        
        self.capitalCity = capitalCity
        self.surface = surface
        self.currentTime = currentTime
        self.timeZone = timeZone
        self.sunrise = sunrise
        self.sunset = sunset
    }
    
    class func data() -> AdministrationData {
        
        return AdministrationData(capitalCity: "" as NSString!,
                                  surface: "" as NSString!,
                                    currentTime: "" as NSString!,
                                    timeZone: "" as NSString!,
                                    sunrise: "" as NSString!,
                                    sunset: "" as NSString!)
    }
    
}