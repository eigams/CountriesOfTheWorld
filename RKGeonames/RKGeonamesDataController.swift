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
        
        var cell: RKGeonamesTableViewCell = self.tableView?.dequeueReusableCellWithIdentifier("RKGeonamesTableViewCell") as RKGeonamesTableViewCell

        if tableView == searchDisplayController.searchResultsTableView {
            
            var country = filteredCountries.objectAtIndex(indexPath.row) as CountryGeonames
            
            return decorateCell(cell, country: country)
        }
        
        
        var country: CountryGeonames = self.countries?.objectAtIndex(indexPath.row) as CountryGeonames
        
        cell.countryNameLabel.text = country.name;
        cell.capitalCityLabel.text = country.capitalCity;        
        
        var image: UIImage? = flags[country.countryCode] as? UIImage
        cell.flagImage.image = image
        
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
        
        return cell
    }
    
    
    func loadFromStorage(items: NSArray?) -> NSArray! {
        
        if items?.count < 1 {
            return nil
        }
        
        var sink = NSMutableArray(capacity: items!.count)
        
        for item in items! {
            sink.addObject(item)
        }
        
        self.countries = sink.copy() as? NSArray
        flags = NSMutableDictionary(capacity: countries!.count)
        
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
    
    func loadFlags() -> NSDictionary {
        
        var items: NSArray = ManagedObjectStore.sharedInstance().allItems(getName(CountryData)) as NSArray
        var index = 0
        
        for country in countries! {
            
            println(country)
            let flagURL = "http://www.geonames.org/flags/x/\((country.countryCode as NSString).lowercaseString).gif"
            
            var session = NSURLSession.sharedSession()
            let url = NSURL.URLWithString(flagURL)
            var task = session.dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
                
                self.flags[country.countryCode] = UIImage(data: data)
                
                self.tableView?.reloadData()
                
                return
            })
            
            task.resume()
        }
        
        return self.flags.copy() as NSDictionary
    }    
    
    func loadRemoteData(success: ((results: NSArray) -> Void),
                        failure: ((error:NSError) -> Void)) -> Void {
        
        var operation = RKGeonamesUtils.setupObjectRequestOperation(NSSelectorFromString("geonamesCountryMapping"),
                                                                    withURL: "http://api.geonames.org/countryInfoJSON?username=sbpuser",
                                                                    pathPattern: nil,
                                                                    andKeyPath: "geonames");
                            
        let predicate = NSPredicate(format: "SELF.capitalCity != ''")
                            
        operation.setCompletionBlockWithSuccess({ (operation: RKObjectRequestOperation!, mappingResult: RKMappingResult!) -> Void in

                                                    var rkItems = mappingResult.array() as NSArray
                                                    rkItems = rkItems.filteredArrayUsingPredicate(predicate)
            
                                                    rkItems = rkItems.sortedArrayUsingComparator({ (obj1: AnyObject!, obj2: AnyObject!) -> NSComparisonResult in
                                                        var cgo1: CountryGeonames = obj1 as CountryGeonames
                                                        var cgo2: CountryGeonames = obj2 as CountryGeonames
                                                        return cgo1.name.compare(cgo2.name)
                                                    })
            
                                                    success(results: rkItems);
            
                                                }, failure: { (operation: RKObjectRequestOperation!, error: NSError!) -> Void in
                                                    failure(error: error);
                                                }
        )
                            
        operation.start();
    }
    
}
