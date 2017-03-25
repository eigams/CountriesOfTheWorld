//
//  GEOMainViewController.swift
//  RKGeonames
//
//  Created by Stefan Buretea on 1/16/17.
//  Copyright © 2017 Stefan Burettea. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class GEOMainViewController: UITableViewController {
    struct Constants {
        static let navigationItemLabelText = "COUNTRIES OF THE WORLD"
        static let navigationItemLabelFont = "Arial-BoldMT"
        static let navigationItemLabelFontSize:CGFloat = 14
        static let navigationItemLabelTextColor = UIColor(red: 0.22, green: 0.33, blue: 0.53, alpha: 1)
        
        static let tableViewRowHeight: CGFloat = 90
    }
    
    @IBOutlet weak var searchingMessageLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!

    fileprivate var searchController: UISearchController?
    fileprivate var countryFlagsCache = GEOCountryFlags()
    fileprivate let disposeBag = DisposeBag()
    
    var countries: [GEOCountry] = [] {
        didSet {
            countries.forEach {
                GEOHTTPClient.requestCountryFlag(with: GEOCountryFlagRequest(country: $0))
                    .subscribe(onNext: { [unowned self] (image: (String, UIImage)) in
                        self.countryFlagsCache[image.0] = image.1
                        if let index = self.countries.index(where: { $0.countryCode == image.0 }) {
                            self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
                        } else {
                            self.tableView.reloadData()
                        }
                    })
                    .addDisposableTo(disposeBag)
            }
        }
    }
    
    var filteredTableData: [GEOCountry]?

    fileprivate func setupNavigationBarTitle() {
        let label = UILabel(frame: .zero)
        label.backgroundColor = UIColor.clear
        label.font = UIFont(name: Constants.navigationItemLabelFont, size: Constants.navigationItemLabelFontSize)
        label.shadowColor = UIColor(white: 1.0, alpha: 0.5)
        label.textAlignment = .center
        label.textColor = Constants.navigationItemLabelTextColor
        
        navigationItem.titleView = label
        label.text = Constants.navigationItemLabelText
        label.sizeToFit()
    }
    
    fileprivate func setupSearchController() {
        searchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = true
            controller.searchBar.sizeToFit()
            
            self.tableView.tableHeaderView = controller.searchBar
            
            return controller
        })()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchController()
        setupNavigationBarTitle()
        navigationController?.isToolbarHidden = true
    }

    func configureTableViewTop() {
        tableView.contentInset.bottom = UIApplication.shared.statusBarFrame.height
    }
}


// MARK: UITableView delegates
extension GEOMainViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchController?.isActive ?? false ? filteredTableData?.count ?? 0 : countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "GEOMainTableViewCell",for: indexPath) as? GEOMainTableViewCell {
            if let isActive = searchController?.isActive, isActive == true {
                if let filteredTableData = filteredTableData {
                    cell.configure(with: filteredTableData[indexPath.row], flag: countryFlagsCache[filteredTableData[indexPath.row].countryCode ?? ""] ?? UIImage())
                }
            } else {
                cell.configure(with: countries[indexPath.row], flag: countryFlagsCache[countries[indexPath.row].countryCode ?? ""] ?? UIImage())
            }
            
            cell.backgroundColor = UIColor.colorForIndex(UInt(indexPath.row), of: UInt(self.countries.count))
            return cell
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.tableViewRowHeight
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let countryDetailsViewController = storyboard?.instantiateViewController(withIdentifier: "CountryDetailsViewController") as? GEOCountryDetailsViewController {
            navigationController?.pushViewController(countryDetailsViewController, animated: true)
            countryDetailsViewController.country = countries[indexPath.row]            
            
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }
}

//MARK: SearchBar delegate
extension GEOMainViewController: UISearchResultsUpdating {
    public func updateSearchResults(for searchController: UISearchController) {
        let searchPredicate = NSPredicate { (country, _) -> Bool in
            guard let country = country as? GEOCountry else { return false }
            
            return country.countryName?.range(of: searchController.searchBar.text!) != nil
        }
        filteredTableData = (countries as NSArray).filtered(using: searchPredicate) as? [GEOCountry]
        
        self.tableView.reloadData()
    }
}

private extension UIColor {
    static func colorForIndex(_ index: UInt, of totalItems: UInt) -> UIColor {
        var indexDiv = index % 10
        if indexDiv > 5 {
            indexDiv = 10 - indexDiv - 1
        }
        
        let red = (Double(indexDiv)/Double(totalItems - 1))*4
        let green = (Double(indexDiv)/Double(totalItems - 1))*3
        
        return UIColor(red: CGFloat(red)+0.86, green: CGFloat(green)+0.93, blue: 1, alpha: 1)
    }
}

