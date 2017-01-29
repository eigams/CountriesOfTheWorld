//
//  GEOTimezoneRequest.swift
//  Pods
//
//  Created by Stefan Buretea on 1/18/17.
//
//

import Foundation


struct GEOTimezoneRequest {
    let latitude: Float
    let longitude: Float
    
    var url:String {
        return String(format:"http://api.geonames.org/timezoneJSON?lat=%.2f&lng=%.2f&username=sbpuser", latitude, longitude).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    }
    
    init?(latitude: String?, longitude: String?) {
        guard let latitude = latitude, let longitude = longitude else { return nil }
        
        self.latitude = Float(latitude) ?? 0.0
        self.longitude = Float(longitude) ?? 0.0
    }
    
}
