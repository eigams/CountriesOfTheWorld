//
//  EconomicalData.swift
//  RKGeonames
//
//  Created by Stefan Buretea on 9/21/14.
//  Copyright (c) 2014 Stefan Burettea. All rights reserved.
//

import Foundation
import CoreData

class EconomicalData: NSManagedObject {

    @NSManaged var gdp: String
    @NSManaged var gdppercapita: String
    @NSManaged var gnipercapita: String
    @NSManaged var year: String
    @NSManaged var countryData: CountryData

}
