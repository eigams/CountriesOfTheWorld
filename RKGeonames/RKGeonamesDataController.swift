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
    
    private var countries: NSMutableArray?
    private var flags: NSMutableDictionary
    var tableView: UITableView?
    var searchDisplayController: UISearchDisplayController!
    var filteredCountries: NSArray!
    
    override init()  {
        countries = NSMutableArray()
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
        
        
        var country: CountryGeonames = countries?.objectAtIndex(indexPath.row) as CountryGeonames
        
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
        filteredCountries = countries!.filteredArrayUsingPredicate(resultPredicate) as NSArray!
    }
    
    
    func decorateCell (cell: RKGeonamesTableViewCell, country:CountryGeonames) -> RKGeonamesTableViewCell {
        
        cell.countryNameLabel.text = country.name;
        cell.capitalCityLabel.text = country.capitalCity;
        cell.accessoryType = UITableViewCellAccessoryType.DetailDisclosureButton
    
        cell.flagImage.image = flags[country.countryCode] as? UIImage
        
        return cell
    }
    
    
    func loadFromStorage(items: NSArray?) -> NSArray! {
        
        if items == nil {
            return nil
        }
        
        if items!.count < 1 {
            return nil
        }
        
        countries = NSMutableArray(capacity: items!.count)
        
        for item in items! {
            let countryGeonames = CountryGeonames()
            
            countryGeonames.name = item.name;
            countryGeonames.currency = item.currency;
            countryGeonames.capitalCity = item.capitalCity;
            countryGeonames.areaInSqKm = item.surface;
            countryGeonames.north = item.north;
            countryGeonames.south = item.south;
            countryGeonames.east = item.east;
            countryGeonames.west = item.west;
            countryGeonames.countryCode = item.countryCode;
            
            countries?.addObject(countryGeonames)
        }
        
        flags = NSMutableDictionary(capacity: countries!.count)
        
        return countries?.copy() as NSArray
    }
    
    func getName(classType:AnyClass) -> String {
        
        let classString = NSStringFromClass(classType.self)
        let range = classString.rangeOfString(".", options: NSStringCompareOptions.CaseInsensitiveSearch, range: Range<String.Index>(start:classString.startIndex, end: classString.endIndex), locale: nil)
        
        if range == nil {
            return classString
        }
        
        return classString.substringFromIndex(range!.endIndex)
    }
    
    func loadFlags() -> NSDictionary {
        
        var items: NSArray = ManagedObjectStore.sharedInstance().allItems(getName(CountryData)) as NSArray
        
        var index = 0
        let maxIndex = 10
        
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
        
        return flags.copy() as NSDictionary
    }
}
