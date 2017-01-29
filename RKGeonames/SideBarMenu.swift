//
//  SideBarMenu.swift
//  DynamicsDemo
//
//  Created by Stefan Buretea on 3/31/15.
//  Copyright (c) 2015 Stefan Buretea. All rights reserved.
//

import UIKit

@objc protocol SideBarMenuDelegate {
    
    func sideBarMenu(_ menu: SideBarMenu, didSelectItemAtIndex index: Int)
    
    @objc optional func sideBarMenuWillClose(_ menu: SideBarMenu)
    @objc optional func sideBarMenuWillOpen(_ menu: SideBarMenu)
}

class SideBarMenu: NSObject, SideBarMenuViewControllerDelegate {
   
    fileprivate let barWidth: CGFloat = 160
    fileprivate let sideBarTableViewInset: CGFloat = 89.0
    fileprivate let sideBarContainerView: UIView = UIView()
    fileprivate let sideBarViewController: SideBarMenuTableViewController = SideBarMenuTableViewController()
    fileprivate var originView: UIView!
    fileprivate var glassView: UIView = UIView()
    
    fileprivate var animator: SideBarMenuAnimator!
    var delegate: SideBarMenuDelegate?
    fileprivate var isOpen: Bool = false
    
    override init() {
        super.init()
    }
    
    @available(iOS 8.0, *)
    init(sourceView: UIView, menuItems: Array<String>, menuImages: Array<String>) {
        super.init()
        
        self.originView = sourceView
        self.sideBarViewController.tableData = menuItems
        self.sideBarViewController.tableDataImages = menuImages
        
        setup()
        
        self.animator = SideBarMenuAnimator(originView: self.originView)
        
        let showGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(SideBarMenu.handleSwipe(_:)))
        showGestureRecognizer.direction = UISwipeGestureRecognizerDirection.right
        self.originView.addGestureRecognizer(showGestureRecognizer)
        
        let hideGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(SideBarMenu.handleSwipe(_:)))
        hideGestureRecognizer.direction = UISwipeGestureRecognizerDirection.left
        self.originView.addGestureRecognizer(hideGestureRecognizer)
        
    }
    
    @available(iOS 8.0, *)
    fileprivate func setup() {
        
        self.glassView.frame = self.originView.bounds
        self.glassView.backgroundColor = UIColor.clear
        self.glassView.isHidden = true
        self.originView.addSubview(self.glassView)
        
        self.sideBarContainerView.frame = CGRect(x: -self.barWidth - 1, y: self.originView.frame.origin.y, width: self.barWidth, height: self.originView.frame.size.height)
//        self.sideBarContainerView.backgroundColor = UIColor(red: 0.4, green: 0.5, blue: 0.15, alpha: 1.0).colorWithAlphaComponent(0.1)
//        self.sideBarContainerView.backgroundColor = UIColor(red: 0.0, green: 0.47, blue: 0.53, alpha: 1.0)
        self.sideBarContainerView.backgroundColor = UIColor.clear
        self.sideBarContainerView.clipsToBounds = false
        
        self.originView.addSubview(self.sideBarContainerView)
        
        let blurView:UIVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.light))
        blurView.frame = self.sideBarContainerView.bounds
        self.sideBarContainerView.addSubview(blurView)
        
        self.sideBarViewController.delegate = self
        self.sideBarViewController.tableView.frame = self.sideBarContainerView.bounds
        self.sideBarViewController.tableView.clipsToBounds = false
        self.sideBarViewController.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.sideBarViewController.tableView.backgroundColor = UIColor.clear
        self.sideBarViewController.tableView.scrollsToTop = false
        self.sideBarViewController.tableView.alwaysBounceVertical = false
        self.sideBarViewController.tableView.contentInset = UIEdgeInsetsMake(self.sideBarTableViewInset, 0, 0, 0)
        
        self.sideBarViewController.tableView.reloadData()
        
        self.sideBarContainerView.addSubview(self.sideBarViewController.tableView)
    }
    
    @objc fileprivate func handleSwipe(_ gestureRecognizer: UISwipeGestureRecognizer) {
        show(gestureRecognizer.direction == UISwipeGestureRecognizerDirection.right)
        if gestureRecognizer.direction == UISwipeGestureRecognizerDirection.right {
            self.delegate?.sideBarMenuWillOpen?(self)
        }
        else {
            self.delegate?.sideBarMenuWillClose?(self)
            
            if let lastIndexPath = self.sideBarViewController.lastSelectedCellIndexPath {
                self.sideBarViewController.tableView.deselectRow(at: lastIndexPath as IndexPath, animated: false)
            }
        }        
    }
    
    fileprivate func show(_ shouldOpen: Bool) {
        self.animator.play(shouldOpen, containerView: self.sideBarContainerView)
        self.isOpen = shouldOpen
        
        self.glassView.isHidden = !shouldOpen        
    }
    
    func show() {
        self.show(true)
    }
    
    func hide() {
        self.sideBarContainerView.isHidden = true
    }
    
    func didSelectItem(_ indexPath: IndexPath) {
        self.delegate?.sideBarMenu(self, didSelectItemAtIndex: indexPath.row)
        
        show(false)
        self.delegate?.sideBarMenuWillClose?(self)
        
        if let lastIndexPath = self.sideBarViewController.lastSelectedCellIndexPath {
            self.sideBarViewController.tableView.deselectRow(at: lastIndexPath as IndexPath, animated: false)
        }
    }
    
}
