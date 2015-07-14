//
//  BounceTransitionAnimator.swift
//  CountriesOfTheWorld
//
//  Created by Stefan Buretea on 5/7/15.
//  Copyright (c) 2015 Stefan Buretea. All rights reserved.
//

import UIKit

class BounceTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    weak var transitionContext: UIViewControllerContextTransitioning?
    var appearing: Bool = false
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.5
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        let fromView = fromVC?.view
        let toView = toVC?.view
        let containerView = transitionContext.containerView()
        let duration = self.transitionDuration(transitionContext)
        
        let initialFrame = transitionContext.initialFrameForViewController(fromVC!)

        let offscreenRect = CGRectMake(initialFrame.origin.x + CGRectGetWidth(initialFrame), initialFrame.origin.y, initialFrame.width, initialFrame.height)
        
        // Presenting
        if self.appearing {
            // Position the view offscreen
            toView!.frame = offscreenRect;
            containerView.addSubview(toView!)
            
            // Animate the view onscreen
            UIView.animateWithDuration( 1.0,
                                        delay: 0.0,
                                        usingSpringWithDamping: 0.7,
                                        initialSpringVelocity: 2.0,
                                        options: .CurveEaseIn,
                                        animations: {
                                            toView!.frame = initialFrame
                                            if toVC!.respondsToSelector("setSidebarMenuVisibility:") {
                                                (toVC! as! RKCountryDetailsViewController).setSidebarMenuVisibility(true)
                                            }
                                        },
                                        completion: { (complete: Bool) in
                                            if toVC!.respondsToSelector("setSidebarMenuVisibility:") {
                                                (toVC! as! RKCountryDetailsViewController).setSidebarMenuVisibility(false)
                                            }
                                            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                                        }
            )
        }
            // Dismissing
        else {
            containerView.addSubview(toView!)
            containerView.sendSubviewToBack(toView!)
            
            // Animate the view offscreen
            UIView.animateWithDuration( 1.0,
                delay: 0.0,
                usingSpringWithDamping: 1.0,
                initialSpringVelocity: 1.0,
                options: .CurveEaseIn,
                animations: {
                    fromView!.frame = offscreenRect
                },
                completion: { (complete: Bool) in
                    fromView!.removeFromSuperview()
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                    
                    return
            })
        }
    }
    
    override func animationDidStop(anim: CAAnimation!, finished flag: Bool) {

    }
}
