//
//  SideBarMenuTableViewController.swift
//  DynamicsDemo
//
//  Created by Stefan Buretea on 3/31/15.
//  Copyright (c) 2015 Stefan Buretea. All rights reserved.
//

import UIKit

protocol SideBarMenuViewControllerDelegate {
    func didSelectItem(indexPath: NSIndexPath)
}

class SideBarMenuTableViewController: UITableViewController, SideBarMenuViewControllerDelegate {

    var delegate : SideBarMenuViewControllerDelegate?
    var tableData: Array<String> = []
    var tableDataImages: Array<String> = []
    var lastSelectedCellIndexPath: NSIndexPath?
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return tableData.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("sideBarMenuCell") as? UITableViewCell

        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "sideBarMenuCell")
            
            // Configure the cell...
            configureCell(cell!)
        }
        
        cell!.textLabel?.text = tableData[indexPath.row]
        cell!.imageView?.image = UIImage(named: self.tableDataImages[indexPath.row])
        cell!.imageView?.tintColor = UIColor.blueColor()
        
        return cell!
    }
    
    private func configureCell(cell: UITableViewCell) {
        
        cell.backgroundColor = UIColor.clearColor()
        cell.textLabel?.textColor = UIColor(red: 0, green: 0, blue: 0.5, alpha: 1)
        cell.textLabel?.font = UIFont(name: "Arial-BoldMT", size: 10.0)
        
        let selectedView = UIView(frame: CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height))
        selectedView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.3)
        
        cell.selectedBackgroundView = selectedView
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50.0
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.delegate?.didSelectItem(indexPath)
        self.lastSelectedCellIndexPath = indexPath
    }
    
    func didSelectItem(indexPath: NSIndexPath) {
        
    }
}
