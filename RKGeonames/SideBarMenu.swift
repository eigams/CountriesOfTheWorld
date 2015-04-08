//
//  SideBarMenu.swift
//  DynamicsDemo
//
//  Created by Stefan Buretea on 3/31/15.
//  Copyright (c) 2015 Stefan Buretea. All rights reserved.
//

import UIKit

@objc protocol SideBarMenuDelegate {
    
    func didSelectItemAtIndex(index: Int)
    
    optional func menuWillClose()
    optional func menuWillOpen()
}

class SideBarMenu: NSObject, SideBarMenuViewControllerDelegate {
   
    private let barWidth: CGFloat = 160
    private let sideBarTableViewInset: CGFloat = 89.0
    private let sideBarContainerView: UIView = UIView()
    private let sideBarViewController: SideBarMenuTableViewController = SideBarMenuTableViewController()
    private var originView: UIView!
    private var glassView: UIView = UIView()
    
    var animator: UIDynamicAnimator!
    var delegate: SideBarMenuDelegate?
    var isOpen: Bool = false
    
    override init() {
        super.init()
    }
    
    init(sourceView: UIView, menuItems: Array<String>, menuImages: Array<String>) {
        super.init()
        
        self.originView = sourceView
        self.sideBarViewController.tableData = menuItems
        self.sideBarViewController.tableDataImages = menuImages
        
        setup()
        
        self.animator = UIDynamicAnimator(referenceView: self.originView)
        
        let showGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "handleSwipe:")
        showGestureRecognizer.direction = UISwipeGestureRecognizerDirection.Right
        self.originView.addGestureRecognizer(showGestureRecognizer)
        
        let hideGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "handleSwipe:")
        hideGestureRecognizer.direction = UISwipeGestureRecognizerDirection.Left
        self.originView.addGestureRecognizer(hideGestureRecognizer)
        
    }
    
    func setup() {
        
        self.glassView.frame = self.originView.bounds
        self.glassView.backgroundColor = UIColor.clearColor()
        self.glassView.hidden = true
        self.originView.addSubview(self.glassView)
        
        self.sideBarContainerView.frame = CGRectMake(-self.barWidth - 1, self.originView.frame.origin.y, self.barWidth, self.originView.frame.size.height)
//        self.sideBarContainerView.backgroundColor = UIColor(red: 0.4, green: 0.5, blue: 0.15, alpha: 1.0).colorWithAlphaComponent(0.1)
//        self.sideBarContainerView.backgroundColor = UIColor(red: 0.0, green: 0.47, blue: 0.53, alpha: 1.0)
        self.sideBarContainerView.backgroundColor = UIColor.clearColor()
        self.sideBarContainerView.clipsToBounds = false
        
        self.originView.addSubview(self.sideBarContainerView)
        
        let blurView:UIVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Light))
        blurView.frame = self.sideBarContainerView.bounds
        self.sideBarContainerView.addSubview(blurView)
        
        self.sideBarViewController.delegate = self
        self.sideBarViewController.tableView.frame = self.sideBarContainerView.bounds
        self.sideBarViewController.tableView.clipsToBounds = false
        self.sideBarViewController.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.sideBarViewController.tableView.backgroundColor = UIColor.clearColor()
        self.sideBarViewController.tableView.scrollsToTop = false
        self.sideBarViewController.tableView.alwaysBounceVertical = false
        self.sideBarViewController.tableView.contentInset = UIEdgeInsetsMake(self.sideBarTableViewInset, 0, 0, 0)
        
        self.sideBarViewController.tableView.reloadData()
        
        self.sideBarContainerView.addSubview(self.sideBarViewController.tableView)
        
    }
    
    func handleSwipe(gestureRecognizer: UISwipeGestureRecognizer) {
        
        if gestureRecognizer.direction == UISwipeGestureRecognizerDirection.Right {
            show(true)
            self.delegate?.menuWillOpen?()
        }
        else {
            show(false)
            self.delegate?.menuWillClose?()
            
            if let lastIndexPath = self.sideBarViewController.lastSelectedCellIndexPath {
                self.sideBarViewController.tableView.deselectRowAtIndexPath(self.sideBarViewController.lastSelectedCellIndexPath!, animated: false)
            }
        }        
    }
    
    func show(shouldOpen: Bool) {
        
        self.animator.removeAllBehaviors()
        self.isOpen = shouldOpen
        
        self.glassView.hidden = !shouldOpen
        
        let gravityX:CGFloat = shouldOpen ? 0.8 : -0.8
        let magnitude:CGFloat = shouldOpen ? 40: -40
        let boundaryX:CGFloat = shouldOpen ? barWidth : -barWidth - 1
        
        let gravityBehaviour = UIGravityBehavior(items: [self.sideBarContainerView])
        gravityBehaviour.gravityDirection = CGVectorMake(gravityX, 0)
        self.animator.addBehavior(gravityBehaviour)
        
        let collisionBehaviour = UICollisionBehavior(items: [self.sideBarContainerView])
        collisionBehaviour.addBoundaryWithIdentifier("sideBarBoundary", fromPoint: CGPointMake(boundaryX, 20), toPoint: CGPointMake(boundaryX, originView.frame.size.height))
        self.animator.addBehavior(collisionBehaviour)
        
        let pushBehaviour = UIPushBehavior(items: [self.sideBarContainerView], mode: UIPushBehaviorMode.Instantaneous)
        pushBehaviour.magnitude = magnitude
        self.animator.addBehavior(pushBehaviour)
        
        let dynamicItem = UIDynamicItemBehavior(items: [self.sideBarContainerView])
        dynamicItem.elasticity = 0.3
        self.animator.addBehavior(dynamicItem)
    }
    
    func hide() {
        self.sideBarContainerView.hidden = true
    }
    
    func didSelectItem(indexPath: NSIndexPath) {
        self.delegate?.didSelectItemAtIndex(indexPath.row)
        
        show(false)
        self.delegate?.menuWillClose?()
        
        if let lastIndexPath = self.sideBarViewController.lastSelectedCellIndexPath {
            self.sideBarViewController.tableView.deselectRowAtIndexPath(self.sideBarViewController.lastSelectedCellIndexPath!, animated: false)
        }
    }
    
}
