    //
//  RKGeonamesDataController.swift
//  RKGeonames
//
//  Created by Stefan Buretea on 9/16/14.
//  Copyright (c) 2014 Stefan Burettea. All rights reserved.
//

import Foundation
import UIKit

class RKGeonamesDataController : NSObject, UITableViewDataSource {
    
    private var countries: NSArray?
    private var flags: NSMutableDictionary
    var tableView: UITableView?
    var searchDisplayController: UISearchDisplayController!
    var filteredCountries: NSArray!
    
    override init()  {
        countries = NSArray()
        flags = NSMutableDictionary()
        filteredCountries = NSArray()
    }
    
    //MARK: UITableView data source delegates
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == searchDisplayController.searchResultsTableView {
            return filteredCountries.count
        }
        
        return countries!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: RKGeonamesTableViewCell = self.tableView?.dequeueReusableCellWithIdentifier("RKGeonamesTableViewCell") as! RKGeonamesTableViewCell

        if tableView == searchDisplayController.searchResultsTableView {
            
            let country = filteredCountries.objectAtIndex(indexPath.row) as? CountryGeonames
            
            if let unwrapped = country {
                return decorateCell(cell, country: unwrapped)
            } else {
                return UITableViewCell()
            }
        }
        
        
        var country: CountryGeonames = self.countries?.objectAtIndex(indexPath.row) as! CountryGeonames
        
        cell.countryNameLabel.text = country.name;
        cell.capitalCityLabel.text = country.capitalCity;        
        
        var image: UIImage? = flags[country.countryCode] as? UIImage
        cell.flagImage.contentMode = UIViewContentMode.ScaleToFill
        if let img = image {
            cell.flagImage.image = image
        }
        
        return cell
    }
    
    //MARK: SearchBar delegate
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String!) -> Bool {
        
        // tells the table data to reload when the text changes
        filterContentForSearchText(searchString)
        
        return true
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchScope searchOption: Int) -> Bool {

        self.filterContentForSearchText(self.searchDisplayController!.searchBar.text)
        
        return true
    }
    
    //MARK: Helper functions
    
    func filterContentForSearchText(searchText: String) {
    
        let resultPredicate = NSPredicate(format: "name contains[c] %@", searchText)
        
        filteredCountries = self.countries!.filteredArrayUsingPredicate(resultPredicate) as NSArray!
    }
    
    
    func decorateCell (cell: RKGeonamesTableViewCell, country:CountryGeonames) -> RKGeonamesTableViewCell {
        
        cell.countryNameLabel.text = country.name;
        cell.capitalCityLabel.text = country.capitalCity;
        cell.accessoryType = UITableViewCellAccessoryType.DetailDisclosureButton
    
        cell.flagImage.image = flags[country.countryCode] as? UIImage
        
        country.flag = flags[country.countryCode] as? UIImage
        
        return cell
    }
    
    
    func setCountries(items: NSArray?) -> NSArray! {
        
        if items?.count < 1 {
            return nil
        }
        
        self.countries = (items as NSArray!).copy() as? NSArray
        self.flags = NSMutableDictionary(capacity: self.countries!.count)
        
        return self.countries!
    }
    
    func getName(classType:AnyClass) -> String {
        
        let classString = NSStringFromClass(classType.self)
        let range = classString.rangeOfString(".", options: NSStringCompareOptions.CaseInsensitiveSearch,
                                                     range: Range<String.Index>(start:classString.startIndex, end: classString.endIndex), locale: nil)
        
        if range == nil {
            return classString
        }
        
        return classString.substringFromIndex(range!.endIndex)
    }
    
    func loadFlags(completion: () -> Void) -> NSDictionary {
        
        var downloads = 0
        let refreshCount = 15
        
        for country in self.countries! {
            
            let flagURL = "http://www.geonames.org/flags/x/\((country.countryCode as NSString).lowercaseString).gif"
            
            var session = NSURLSession.sharedSession()
            let url = NSURL(string:flagURL) as NSURL!
            var task = session.dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
                
                if nil == error {
                    self.flags[country.countryCode] = UIImage(data: data)
                    
                    if downloads < refreshCount {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.tableView?.reloadData()
                        })
                    }
                    
                    completion()
                    
                    ++downloads
                }
                
                return
            })
            
            task.resume()
        }
        
        self.tableView?.reloadData()
        
        return self.flags.copy() as! NSDictionary
    }    
    
    func imageFlags() -> NSDictionary {
        return self.flags.copy() as! NSDictionary        
    }
    
    class func loadRemoteData(completion: ((results: NSArray?, error: NSError?) -> Void)) -> Void {
        
        var operation = RKGeonamesUtils.setupObjectRequestOperation(NSSelectorFromString("geonamesCountryMapping"),
                                                                    withURL: "http://api.geonames.org/countryInfoJSON?username=sbpuser",
                                                                    pathPattern: nil,
                                                                    andKeyPath: "geonames");
                            
        let predicate = NSPredicate(format: "SELF.capitalCity != ''") as NSPredicate!
                            
        operation.setCompletionBlockWithSuccess({ (operation: RKObjectRequestOperation!, mappingResult: RKMappingResult!) -> Void in

                                                    var rkItems = mappingResult.array() as NSArray
                                                    rkItems = rkItems.filteredArrayUsingPredicate(predicate)
            
                                                    rkItems = sorted(rkItems) {
                                                        (obj1, obj2) in
                                                        
                                                        let cgo1 = obj1 as! CountryGeonames
                                                        let cgo2 = obj2 as! CountryGeonames
                                                        
                                                        return cgo1.name < cgo2.name
                                                    }
            
                                                    completion(results: rkItems, error: nil);
            
                                                }, failure: { (operation: RKObjectRequestOperation!, error: NSError!) -> Void in
                                                    completion(results: nil, error: error);
                                                }
        )
                            
        operation.start();
    }
    
}
