//
//  UITableViewCell+SideBarMenu.swift
//  RKGeonames
//
//  Created by Stefan Buretea on 1/15/16.
//  Copyright © 2016 Stefan Burettea. All rights reserved.
//

import UIKit

extension UITableViewCell {
    func configureForSideBarMenu(_ titleLabelText: String, imageName: String) {
        self.backgroundColor = UIColor.clear
        self.textLabel?.textColor = UIColor(red: 0, green: 0, blue: 0.5, alpha: 1)
        self.textLabel?.font = UIFont(name: "Arial-BoldMT", size: 10.0)
        
        let selectedView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        selectedView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        self.selectedBackgroundView = selectedView
        
        self.textLabel?.text = titleLabelText
        self.imageView?.image = UIImage(named: imageName)
        self.imageView?.tintColor = UIColor.blue
    }
}
