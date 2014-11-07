//
//  RKEconomicalDataClient.swift
//  RKGeonames
//
//  Created by Stefan Buretea on 9/23/14.
//  Copyright (c) 2014 Stefan Burettea. All rights reserved.
//

import Foundation

@objc (RKGEconomicalDataClientDelegate)
protocol RKGEconomicalDataClientDelegate {
    func updateView(client: RKEconomicalDataClient) -> Bool
}

class RKEconomicalDataClient : NSObject {
    
    var delegate: RKGEconomicalDataClientDelegate?
    
    class var sharedInstance: RKEconomicalDataClient {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: RKEconomicalDataClient? = nil
        }
            
        dispatch_once(&Static.onceToken) {
            Static.instance = RKEconomicalDataClient()
        }
        
        return Static.instance!
    }

    func getDataForCountry(country: String) {
        // when no data is stored locally, get it from the net
        
        delegate?.updateView(self)        
    }
}