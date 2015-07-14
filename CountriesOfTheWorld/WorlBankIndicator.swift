//
//  WorlBankIndicator.swift
//  RKGeonames
//
//  Created by Stefan Buretea on 9/24/14.
//  Copyright (c) 2014 Stefan Burettea. All rights reserved.
//

import Foundation


class RKGIndicator : NSObject {

    var id: NSString?
    var value: NSString?
}

class RKGWorldBankCountry : NSObject {

    var id: NSString?
    var value: NSString?
}


class RKGWorldBankIndicator : NSObject {

    var indicator: RKGIndicator?
    var country: RKGWorldBankCountry?
    var value: NSString?
    var decimal: NSString?
    var date: NSString?
}

class RKGWorldBankIndicatorArray : NSObject {

    var indicators: NSArray?
}
