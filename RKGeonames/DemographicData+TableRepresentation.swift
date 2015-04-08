//
//  DemographicData+TableRepresentation.swift
//  RKGeonames
//
//  Created by Stefan Buretea on 9/21/14.
//  Copyright (c) 2014 Stefan Burettea. All rights reserved.
//

import Foundation

extension DemographicData {
    
    func tr_tableRepresentation() -> NSDictionary {
        
        return ["titles" : ["TOTAL POPULATION", "POPULATION GROWTH", "BIRTH RATE", "DEATH RATE"],
                "values" : [self.self.totalPopulation, self.self.populationGrowth, self.self.birthRate, self.self.deathRate]]
    }
}