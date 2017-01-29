//
//  GEOCurrencies.swift
//  Pods
//
//  Created by Stefan Buretea on 1/17/17.
//
//

import Foundation

struct GEOCurrencies {
    static let sharedInstance = GEOCurrencies()
    fileprivate var items: [String:Any]!
    
    fileprivate init() {
        if let keysPath = Bundle.main.path(forResource: "Currencies", ofType: "plist") {
            items = NSDictionary(contentsOfFile: keysPath) as? [String: AnyObject]
        }
    }
    
    subscript(key: String) -> String {
        get {
            return (items[key] as? String) ?? ""
        }
    }
}
