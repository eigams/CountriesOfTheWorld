//
//  RKRemoteDataModel.swift
//  RKGeonames
//
//  Created by Stefan Buretea on 3/2/15.
//  Copyright (c) 2015 Stefan Burettea. All rights reserved.
//

import UIKit

class RKDataModel: NSObject {
    
    let name: String?
    let flag: String?
    
    let capitalCity: String?
    var currentTime: NSDate?
    let timeZone: String?
    var sunrise: String?
    var sunset: String?
    
    var demographicData: Dictionary<String, String>
    
    private let totalPopulation: String?
    private let populationGrowth: String?
    private let birthRate: String?
    private let deathRate: String?
    
    let currency: String?
    var populationData: Dictionary<String, String>
    
    private let gdp: String?
    private let gdppercapita: String?
    private let gnipercapita: String?
    
    override init() {
        
        self.name = String()
        self.flag = String()
        
        self.capitalCity = String()
        self.currentTime = NSDate()
        self.timeZone = String()
        self.sunrise = String()
        self.sunset = String()
        
        self.demographicData = Dictionary<String, String>()
        
        self.totalPopulation = String()
        self.populationGrowth = String()
        self.birthRate = String()
        self.deathRate = String()
        
        self.populationData = Dictionary<String, String>()
        
        self.currency = String()
        self.gdp = String()
        self.gdppercapita = String()
        self.gnipercapita = String()
    }
}
