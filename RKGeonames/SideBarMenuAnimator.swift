//
//  SideBarMenuAnimator.swift
//  RKGeonames
//
//  Created by Stefan Buretea on 1/16/16.
//  Copyright © 2016 Stefan Burettea. All rights reserved.
//

import UIKit

class SideBarMenuAnimator: NSObject {

    fileprivate let originView: UIView!
    fileprivate let animator: UIDynamicAnimator!
    
    init(originView: UIView!) {
        self.originView = originView
        self.animator = UIDynamicAnimator(referenceView: originView)
        super.init()
    }
    
    func play(_ shouldOpen: Bool, containerView: UIView!) {
        self.animator.removeAllBehaviors()
        
        let gravityX:CGFloat = shouldOpen ? 0.8 : -0.8
        let magnitude:CGFloat = shouldOpen ? 40: -40
        let boundaryX:CGFloat = shouldOpen ? containerView.frame.size.width : -containerView.frame.size.width - 1
        
        let gravityBehaviour = UIGravityBehavior(items: [containerView])
        gravityBehaviour.gravityDirection = CGVector(dx: gravityX, dy: 0)
        self.animator.addBehavior(gravityBehaviour)
        
        let collisionBehaviour = UICollisionBehavior(items: [containerView])
        collisionBehaviour.addBoundary(withIdentifier: "sideBarBoundary" as NSCopying, from: CGPoint(x: boundaryX, y: 20), to: CGPoint(x: boundaryX, y: originView.frame.size.height))
        self.animator.addBehavior(collisionBehaviour)
        
        let pushBehaviour = UIPushBehavior(items: [containerView], mode: UIPushBehaviorMode.instantaneous)
        pushBehaviour.magnitude = magnitude
        self.animator.addBehavior(pushBehaviour)
        
        let dynamicItem = UIDynamicItemBehavior(items: [containerView])
        dynamicItem.elasticity = 0.3
        self.animator.addBehavior(dynamicItem)
    }
    
}
