//
//  RKDemographicDataManager.swift
//  RKGeonames
//
//  Created by Stefan Buretea on 4/6/15.
//  Copyright (c) 2015 Stefan Burettea. All rights reserved.
//

import UIKit

class RKDemographicDataManager: NSObject {
    
    private let square = 0x00B2;
    private let loading = "loading ..."
    
    var currentData = [String: [String]]()
    
    var totalPopulation: String = "loading ..."
    var populationGrowth: String = "loading ..."
    var birthRate: String = "loading ..."
    var deathRate: String = "loading ..."
    
    private let TOTAL_POPULATION_INDICATOR_STRING = "SP.POP.TOTL"
    private let POPULATION_GROWTH_INDICATOR_STRING = "SP.POP.GROW"
    private let BIRTH_RATE_INDICATOR_STRING = "SP.DYN.CBRT.IN"
    private let DEATH_RATE_INDICATOR_STRING = "SP.DYN.CDRT.IN"
    private let per_mille:UniChar = 0x2030
    private let TypeFloat:Int16 = 1
    
    private let country: CountryGeonames!
    private let selectedYear: String!
    
    init(country: CountryGeonames!, selectedYear: String!) {
        
        self.country = country
        self.selectedYear = selectedYear
    }
    
    func retrieve(completion: ([String: [String]]?, NSError?) -> Void) {
        
        let populationIndicatorsData = [TOTAL_POPULATION_INDICATOR_STRING: ["totalPopulation", "total", ""],
                                        POPULATION_GROWTH_INDICATOR_STRING: ["populationGrowth", "growth", "%"],
                                        BIRTH_RATE_INDICATOR_STRING: ["birthRate", "birthRate", String(format:"%C", per_mille)],
                                        DEATH_RATE_INDICATOR_STRING: ["deathRate", "deathRate", String(format:"%C", per_mille)]]
        
        var results = DemographicData(totalPopulation: self.totalPopulation, populationGrowth: self.populationGrowth, birthRate: self.birthRate, deathRate: self.deathRate)
        var data = results.tr_tableRepresentation() as! [String: [String]]

        completion(data, nil)

        for (key, value) in populationIndicatorsData {

            self.getIndicatorData(key, info: value[2], completion: { (data: String?, error: NSError?) -> Void in
                
                if nil != error {
                    completion(nil, error)
                    
                    return
                }
                
                self.setValue(data, forKey: value.first!)
                
                results = DemographicData(totalPopulation: self.totalPopulation, populationGrowth: self.populationGrowth, birthRate: self.birthRate, deathRate: self.deathRate)
                var data = results.tr_tableRepresentation() as! [String: [String]]
                
                completion(data, nil)
            })
        }

        self.totalPopulation = loading
        self.populationGrowth = loading
        self.birthRate = loading
        self.deathRate = loading
    }
    
    private func getIndicatorData(indicator: String, info: String, completion: (String?, NSError?) -> Void) {
        
        RKGeonamesUtils.fetchWorldBankIndicator(indicator, countryCode: self.country?.countryCode, year: self.selectedYear != nil ? self.selectedYear : "2012", type: 1, text: info, completion: { (data: String?, error: NSError?) -> Void in
            completion(data, error)
        })
        
    }
}
