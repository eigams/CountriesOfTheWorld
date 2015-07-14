//
//  CountryMoreInfo.swift
//  CountriesOfTheWorld
//
//  Created by Stefan Buretea on 4/13/15.
//  Copyright (c) 2015 Stefan Buretea. All rights reserved.
//

import UIKit

class CountryMoreInfo: NSObject {
    
    private var plistFullPath: String {
        struct Static {
            static let instance: String = {
                
                let plistFileName = NSBundle.mainBundle().pathForResource("AboutCountry", ofType: "plist")
                
                let fm = NSFileManager.defaultManager()
                
                if(fm.fileExistsAtPath(plistFileName!)) {
                    return plistFileName!
                }
                
                return ""
                }()
        }
        
        return Static.instance
    }
    
    func details(country: CountryGeonames) -> [String: String] {
        
        if(self.plistFullPath.isEmpty) {
            return [String: String]()
        }
        
        let infos = NSDictionary(contentsOfFile: self.plistFullPath)
        
        if let dict = infos {
            
            var result = Dictionary<String, [String: String]>()
            
            for key in dict.allKeys {
                
                let stringKey:String = key as! String
                
                if stringKey == country.countryCode {
//                    let value = dict.valueForKey(stringKey)
                    
                    if let keyValue: [String: String] = dict.valueForKey(stringKey) as? [String: String] {
//                        result[stringKey] = keyValue
                        return keyValue
                    }
                }
            }
            
//            return result
        }
        
        return [String: String]()
    }
    
}
