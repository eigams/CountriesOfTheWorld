//
//  PopulationData.swift
//  RKGeonames
//
//  Created by Stefan Buretea on 9/21/14.
//  Copyright (c) 2014 Stefan Burettea. All rights reserved.
//

import Foundation
import CoreData

class PopulationData: NSManagedObject {

    @NSManaged var birthRate: String
    @NSManaged var deathRate: String
    @NSManaged var growth: String
    @NSManaged var total: String
    @NSManaged var year: String
    @NSManaged var countryData: CountryData

}
