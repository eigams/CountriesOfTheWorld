//
//  DemographicData.swift
//  RKGeonames
//
//  Created by Stefan Buretea on 9/21/14.
//  Copyright (c) 2014 Stefan Burettea. All rights reserved.
//

import Foundation

class DemographicData : NSObject {
    
    let totalPopulation: NSString
    let populationGrowth: NSString
    let birthRate: NSString
    let deathRate: NSString
    
    init(totalPopulation: NSString, populationGrowth: NSString, birthRate: NSString, deathRate: NSString) {
        
        self.totalPopulation = totalPopulation
        self.populationGrowth = populationGrowth
        self.birthRate = birthRate
        self.deathRate = deathRate
    }
    
    class func data() -> DemographicData {
        return DemographicData(totalPopulation: "" as NSString!, populationGrowth: "" as NSString!, birthRate: "" as NSString!, deathRate: "" as NSString!)
    }
}