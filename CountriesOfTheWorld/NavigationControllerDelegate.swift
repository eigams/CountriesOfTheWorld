//
//  NavigationControllerDelegate.swift
//  CountriesOfTheWorld
//
//  Created by Stefan Buretea on 5/7/15.
//  Copyright (c) 2015 Stefan Buretea. All rights reserved.
//

import UIKit

class NavigationControllerDelegate: NSObject, UINavigationControllerDelegate {

    @IBOutlet weak var navigationController: UINavigationController!
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        let animator = BounceTransitionAnimator()
        
        if toVC.isKindOfClass(RKCountryDetailsViewController) && operation == UINavigationControllerOperation.Push {
            animator.appearing = true
            
            return animator
        }

        if toVC.isKindOfClass(RKGCountryMoreInfoViewController) && operation == UINavigationControllerOperation.Push {
            animator.appearing = true
            
            return animator
        }

        if fromVC.isKindOfClass(RKCountryDetailsViewController) && operation == UINavigationControllerOperation.Pop {
            animator.appearing = false
            
            return animator
        }
        
        if toVC.isKindOfClass(RKGCountryMoreInfoViewController) && operation == UINavigationControllerOperation.Pop {
            animator.appearing = false
            
            return animator
        }
        
        return animator
    }
    
}
