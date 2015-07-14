//
//  UIButton+RKGeonames.swift
//  CountriesOfTheWorld
//
//  Created by Stefan Buretea on 4/22/15.
//  Copyright (c) 2015 Stefan Buretea. All rights reserved.
//

import UIKit

extension UILabel {
    
    func setGlowEffect() {
        let color = self.textColor;
        self.layer.shadowColor = color.CGColor
        self.layer.shadowRadius = 4.0
        self.layer.shadowOpacity = 0.9
        self.layer.shadowOffset = CGSizeZero
        self.layer.masksToBounds = false
    }
    
}