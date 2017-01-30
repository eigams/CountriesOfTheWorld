//
//  RKCountryMoreInfo.swift
//  RKGeonames
//
//  Created by Stefan Buretea on 4/11/15.
//  Copyright (c) 2015 Stefan Burettea. All rights reserved.
//

import UIKit

class RKCountryMoreInfo: NSObject {

    fileprivate lazy var plistPath: String = {
        guard let documentsDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else { return "" }
        let plistFileName = "AboutCountry.plist"
//        guard let path = NSURL(fileURLWithPath: documentsDirectoryPath).URLByAppendingPathComponent(plistFileName) else {return ""}
        let path = URL(fileURLWithPath: documentsDirectoryPath).appendingPathComponent(plistFileName)
        
        return FileManager.default.fileExists(atPath: path.absoluteString ?? "") ? (path.absoluteString ?? "") : ""
    }()
    
    func detailsForCountry(_ country: GEOCountry) -> [String: String] {
        guard self.plistPath.isEmpty else { return [:] }
        
        guard let infos = NSDictionary(contentsOfFile: self.plistPath) as? [String: String] else { return [:] }
        
        return infos
    }
    
}
