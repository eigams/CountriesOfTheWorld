//
//  RKSplashScreenViewController.swift
//  RKGeonames
//
//  Created by Stefan Buretea on 9/22/14.
//  Copyright (c) 2014 Stefan Burettea. All rights reserved.
//

import Foundation

class RKGSplashScreenViewController : UIViewController {
    
    func dismiss(animated: Bool) {
        dismissViewControllerAnimated(animated, completion: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
    
        dispatch_after(3, dispatch_get_main_queue(), { self.dismiss(animated)})
    }
    
}