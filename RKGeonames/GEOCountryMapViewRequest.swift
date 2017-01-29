//
//  GEOCountryMapViewRequest.swift
//  RKGeonames
//
//  Created by Stefan Buretea on 1/19/17.
//  Copyright © 2017 Stefan Burettea. All rights reserved.
//

import Foundation


struct GEOCountryMapViewRequest {
    fileprivate struct Constants {
        static let MapViewUrlFormat = "http://maps.google.com/maps/api/staticmap?size=%ux%u&&sensor=false&path=color:0x0000ff80|weight:1|fillcolor:0x80FFFF20%@%@%@%@%@&scale=2";
        static let PointFormat = "|%.02f,%.02f"
        
        static let ZoominWidth = 400;
        static let ZoominHeight = 400;
    }
    
    let country: GEOCountry
    var url:String {
        guard let north = country.north, let south = country.south, let east = country.east, let west = country.west else { return "" }
        
        let lah = Float(north) + 0.5
        let lal = Float(south) - 0.5
        let loh = Float(east) + 0.5
        let lol = Float(west) - 0.5
        
        let upperRight = String(format: Constants.PointFormat, lah, loh)
        let upperLeft = String(format: Constants.PointFormat, lah, lol)
        let lowerLeft = String(format: Constants.PointFormat, lal, lol)
        let lowerRight = String(format: Constants.PointFormat, lal, loh)
        
        return String(format: Constants.MapViewUrlFormat, Constants.ZoominWidth, Constants.ZoominHeight, upperRight, upperLeft, lowerLeft, lowerRight, upperRight, zoomFactor).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    }
    
    var zoomFactor:UInt
    
    init(country: GEOCountry, zoomFactor: UInt) {
        self.country = country
        self.zoomFactor = zoomFactor
    }
}
