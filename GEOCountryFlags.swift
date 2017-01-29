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

class GEOCountryFlags {
    fileprivate var cache = NSCache<NSString, UIImage>()
    
    func flag(for countryCode: String) -> UIImage? {
        return cache.object(forKey: (countryCode as NSString))
    }
    
    func addFlag(_ flagImage: UIImage, for countryCode: String) {
        cache.setObject(flagImage, forKey: countryCode as NSString)
    }    
}
