//
//  SideBarMenuTableViewController.swift
//  DynamicsDemo
//
//  Created by Stefan Buretea on 3/31/15.
//  Copyright (c) 2015 Stefan Buretea. All rights reserved.
//

import UIKit

protocol SideBarMenuViewControllerDelegate {
    func didSelectItem(_ indexPath: IndexPath)
}

class SideBarMenuTableViewController: UITableViewController, SideBarMenuViewControllerDelegate {

    var delegate : SideBarMenuViewControllerDelegate?
    var tableData = [String]()
    var tableDataImages: Array<String> = []
    var lastSelectedCellIndexPath: IndexPath?
    fileprivate let HeightForCell:CGFloat = 50.0;
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return tableData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sideBarMenuCell") ?? UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "sideBarMenuCell")
        cell.configureForSideBarMenu(self.tableData[indexPath.row], imageName: self.tableDataImages[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.HeightForCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.didSelectItem(indexPath)
        self.lastSelectedCellIndexPath = indexPath
    }
    
    func didSelectItem(_ indexPath: IndexPath) {
        
    }
}
