//
//  M13ProgressViewRing+GEOAdditions.swift
//  RKGeonames
//
//  Created by Stefan Buretea on 1/16/17.
//  Copyright © 2017 Stefan Burettea. All rights reserved.
//

import Foundation

extension M13ProgressViewRing {
    func configure() {
        self.indeterminate = true
        self.primaryColor = UIColor.white
        self.secondaryColor = UIColor.gray
        self.backgroundRingWidth = 4.0
        self.progressRingWidth = 2.0
    }
    
    func animate(in view: UIView, completion: (() -> Void)?) {
        guard let superview = self.superview else { return }
        
        for constraint in superview.constraints {
            guard constraint.secondItem as? NSObject == self && constraint.firstAttribute == .centerY else { continue }
            
            superview.removeConstraint(constraint)
            
            let newConstraint = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: superview,
                                                   attribute: .top, multiplier: 1, constant: 35)
            newConstraint.isActive = true
            break
        }
        
        UIView.animate( withDuration: 1.0,
                        delay: 0.0,
                        usingSpringWithDamping: 1.0,
                        initialSpringVelocity: 3.0,
                        options: .curveEaseIn,
                        animations: {
                            view.layoutIfNeeded()
                        },
                        completion: { (complete: Bool) in
                            completion?()
                        }
        )
        
    }
}
