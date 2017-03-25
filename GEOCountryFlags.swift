//
//  GEOCountryFlags.swift
//  RKGeonames
//
//  Created by Stefan Buretea on 1/19/17.
//  Copyright © 2017 Stefan Burettea. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

struct GEOCountryFlags {
    private var cache = NSCache<NSString, UIImage>()
    
    subscript(countryCode: String) -> UIImage? {
        get {
            return cache.object(forKey: (countryCode as NSString))
        }
        
        set {
            cache.setObject(newValue ?? UIImage(), forKey: countryCode as NSString)
        }
    }
}
