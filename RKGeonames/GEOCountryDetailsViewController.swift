//
//  GEOCountryDetailsViewController.swift
//  RKGeonames
//
//  Created by Stefan Buretea on 1/18/17.
//  Copyright © 2017 Stefan Burettea. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
//import RxDataSources


class GEOCountryDetailsViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var mapView: UIWebView!
    @IBOutlet var sideBarMenu: SideBarMenu!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    fileprivate enum SidebarMenuItem:Int {
        case administration
        case demographics
        case economics
        
        var displayText: String {
            switch self {
                case .administration:
                    return "ADMINISTRATION"
                case .economics:
                    return "ECONOMICS"
                case .demographics:
                    return "DEMOGRAPHICS"
            }
        }
        
        static let allValues:[SidebarMenuItem] = [.administration, .demographics, .economics]
    }
    
    fileprivate enum Constants {
        static let StartYear:Int = 1970
        static let DefaultMapViewZoomFactor:UInt = 7
    }
    
    fileprivate let disposeBag = DisposeBag()
    
    var country: GEOCountry?
    
    fileprivate var pickerViewData: [String]!
    fileprivate var selectedPickerYear: String!
    
    fileprivate var countryDataObserver: Observable<[GEOCountryDomainDataItem]> = Observable.just([]) {
        didSet {
            tableView.delegate = nil
            tableView.dataSource = nil
            setupTableView()
        }
    }
    
    fileprivate var countryDomainDataType: GEOCountryDomainDataType! {
        didSet {
            countryDataObserver = GEOCountryDomainDataFactory.domainData(for: countryDomainDataType)
                                                                .retrieve()
                                                                .catchErrorJustReturn([])
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPickerView()
        setupSideBarMenu()
        setupMapView()        
    }
    
    fileprivate func setupSideBarMenu() {
        sideBarMenu = SideBarMenu(sourceView:view, menuItems: SidebarMenuItem.allValues.map{ $0.displayText }, menuImages: SidebarMenuItem.allValues.map{ $0.displayText.lowercased() })
        sideBarMenu.delegate = self;
        sideBarMenu(sideBarMenu, didSelectItemAtIndex: 0)
    }

    fileprivate func setupTableView() {
//        let dataSource = RxTableViewSectionedReloadDataSource<GEOSectionOfCountryDomainDataItem>()
//        dataSource.configureCell = { dataSource, tableView, indexPath, item in
//            let cell = tableView.dequeueReusableCell(withIdentifier: "CountryDetailsTableViewCell") ?? UITableViewCell(style: .value2, reuseIdentifier: "Cell")
//            cell.textLabel?.text = item.title
//            cell.detailTextLabel?.text = item.value
//            
//            return cell
//        }
//
//        countryDataObserver.observeOn(MainScheduler.instance)
//                            .flatMapLatest({ items -> Observable<[GEOSectionOfCountryDomainDataItem]> in
//                                .just([GEOSectionOfCountryDomainDataItem(header: "", items: items)])
//                            })
//                            .bindTo(tableView.rx.items(dataSource: dataSource))
//                            .addDisposableTo(disposeBag)
//        
//        tableView.rx.setDelegate(self)
//                    .addDisposableTo(disposeBag)
    }
    
    fileprivate func setupPickerView() {
        pickerViewData = (Constants.StartYear...NSCalendar.current.component(.year, from: NSDate() as Date)).reversed().map { "\($0)" }
        selectedPickerYear = "\(NSCalendar.current.component(.year, from: NSDate() as Date) - 3)"
        pickerView.reloadAllComponents()
        pickerView.selectRow(3, inComponent: 0, animated: true)
    }
    
    fileprivate func setupMapView() {
        guard let country = country else { return }
        
        if let url = URL(string: GEOCountryMapViewRequest(country: country, zoomFactor: Constants.DefaultMapViewZoomFactor).url) {
            mapView.scalesPageToFit = true
            mapView.loadRequest(URLRequest(url: url))
            mapView.alpha = 1
        }
    }
}


//MARK: UITableViewDelegate
extension GEOCountryDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear

        cell.textLabel?.textColor = .white
        cell.detailTextLabel?.textColor = .white
        
        cell.textLabel?.font = UIFont.arialBoldMTFont(size: 12)
        cell.detailTextLabel?.font = UIFont.arialBoldMTFont(size: 13)
    }
}

//MARK: UIPickerViewDelegate
extension GEOCountryDetailsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerViewData.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerRowLabelView = view as? UILabel
        if pickerRowLabelView == nil {
            pickerRowLabelView = UILabel()
            
            pickerRowLabelView?.font = UIFont.arialBoldMTFont(size: 16)
            pickerRowLabelView?.textAlignment = .center
            pickerRowLabelView?.numberOfLines = 1
            pickerRowLabelView?.textColor = UIColor.white
        }
        
        pickerRowLabelView?.text = pickerViewData[row]
        return pickerRowLabelView ?? UIView()
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedPickerYear = pickerViewData[row]
        
        if case let GEOCountryDomainDataType.economic(country, _) = countryDomainDataType as GEOCountryDomainDataType {
            countryDomainDataType = .economic(country, selectedPickerYear)
        } else if case let GEOCountryDomainDataType.demographic(country, _) = countryDomainDataType as GEOCountryDomainDataType {
            countryDomainDataType = .demographic(country, selectedPickerYear)
        }
    }
}

//MARK: UIWebViewDelegate
extension GEOCountryDetailsViewController: UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        activityIndicator.stopAnimating()
    }
}

//MARK: SideBarMenuDelegate
extension GEOCountryDetailsViewController: SideBarMenuDelegate {
    func sideBarMenu(_ menu: SideBarMenu, didSelectItemAtIndex index: Int) {
        guard let country = country else { return }
        
        pickerView.isHidden = false
        
        guard let menuItem = SidebarMenuItem(rawValue: index) else { return }
        switch menuItem {
            case .demographics:
                countryDomainDataType = .demographic(country, selectedPickerYear)
            case .economics:
                countryDomainDataType = .economic(country, selectedPickerYear)
            case .administration:
                countryDomainDataType = .administration(country, selectedPickerYear)
                pickerView.isHidden = true
        }
    }
}

extension GEOCountryDetailsViewController {
    @IBAction func backButtonTapped(sender: UIButton) {
        sideBarMenu.hide()
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func menuButtonTapped(sender: UIButton) {
        sideBarMenu.show()
    }
}

extension UIFont {
    static func arialBoldMTFont(size: CGFloat) -> UIFont? {
        return UIFont(name: "Arial-BoldMT", size: size)
    }
}
