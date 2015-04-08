//
//  RKCountryDetailsDataController.swift
//  RKGeonames
//
//  Created by Stefan Buretea on 4/3/15.
//  Copyright (c) 2015 Stefan Burettea. All rights reserved.
//

import UIKit

class RKCountryDetailsDataController: NSObject, UITableViewDataSource, UIPickerViewDataSource {
   
    private let cellIdentifier = "geonamesCell"
    private let textLabelKey = "titles"
    private var country: CountryGeonames?
    private var numberFormatter: NSNumberFormatter {
        
        struct Static {
            static let instance: NSNumberFormatter = {
                let formatter = NSNumberFormatter()
                formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
                
                return formatter
            }()
        }
        
        return Static.instance
    }
    
    private var currencies: [String: String] {
        
        struct Static {
            static let instance: [String: String] = {
                
                let data = ["AED": "United Arab Emirates Dirham",
                "AFN": "Afghanistan Afghani",
                "ALL": "Albania Lek",
                "AMD": "Armenia Dram",
                "ANG": "Netherlands Antilles Guilder",
                "AOA": "Angola Kwanza",
                "ARS": "Argentina Peso",
                "AUD": "Australia Dollar",
                "AWG": "Aruba Guilder",
                "AZN": "Azerbaijan New Manat",
                "BAM": "Bosnia and Herzegovina Convertible Marka",
                "BBD": "Barbados Dollar",
                "BDT": "Bangladesh Taka",
                "BGN": "Bulgaria Lev",
                "BHD": "Bahrain Dinar",
                "BIF": "Burundi Franc",
                "BMD": "Bermuda Dollar",
                "BND": "Brunei Darussalam Dollar",
                "BOB": "Bolivia Boliviano",
                "BRL": "Brazil Real",
                "BSD": "Bahamas Dollar",
                "BTN": "Bhutan Ngultrum",
                "BWP": "Botswana Pula",
                "BYR": "Belarus Ruble",
                "BZD": "Belize Dollar",
                "CAD": "Canada Dollar",
                "CDF": "Congo/Kinshasa Franc",
                "CHF": "Switzerland Franc",
                "CLP": "Chile Peso",
                "CNY": "China Yuan Renminbi",
                "COP": "Colombia Peso",
                "CRC": "Costa Rica Colon",
                "CUC": "Cuba Convertible Peso",
                "CUP": "Cuba Peso",
                "CVE": "Cape Verde Escudo",
                "CZK": "Czech Republic Koruna",
                "DJF": "Djibouti Franc",
                "DKK": "Denmark Krone",
                "DOP": "Dominican Republic Peso",
                "DZD": "Algeria Dinar",
                "EGP": "Egypt Pound",
                "ERN": "Eritrea Nakfa",
                "ETB": "Ethiopia Birr",
                "EUR": "Euro Member Countries",
                "FJD": "Fiji Dollar",
                "FKP": "Falkland Islands (Malvinas) Pound",
                "GBP": "United Kingdom Pound",
                "GEL": "Georgia Lari",
                "GGP": "Guernsey Pound",
                "GHS": "Ghana Cedi",
                "GIP": "Gibraltar Pound",
                "GMD": "Gambia Dalasi",
                "GNF": "Guinea Franc",
                "GTQ": "Guatemala Quetzal",
                "GYD": "Guyana Dollar",
                "HKD": "Hong Kong Dollar",
                "HNL": "Honduras Lempira",
                "HRK": "Croatia Kuna",
                "HTG": "Haiti Gourde",
                "HUF": "Hungary Forint",
                "IDR": "Indonesia Rupiah",
                "ILS": "Israel Shekel",
                "IMP": "Isle of Man Pound",
                "INR": "India Rupee",
                "IQD": "Iraq Dinar",
                "IRR": "Iran Rial",
                "ISK": "Iceland Krona",
                "JEP": "Jersey Pound",
                "JMD": "Jamaica Dollar",
                "JOD": "Jordan Dinar",
                "JPY": "Japan Yen",
                "KES": "Kenya Shilling",
                "KGS": "Kyrgyzstan Som",
                "KHR": "Cambodia Riel",
                "KMF": "Comoros Franc",
                "KPW": "Korea (North) Won",
                "KRW": "Korea (South) Won",
                "KWD": "Kuwait Dinar",
                "KYD": "Cayman Islands Dollar",
                "KZT": "Kazakhstan Tenge",
                "LAK": "Laos Kip",
                "LBP": "Lebanon Pound",
                "LKR": "Sri Lanka Rupee",
                "LRD": "Liberia Dollar",
                "LSL": "Lesotho Loti",
                "LTL": "Lithuania Litas",
                "LVL": "Latvia Lat",
                "LYD": "Libya Dinar",
                "MAD": "Morocco Dirham",
                "MDL": "Moldova Leu",
                "MGA": "Madagascar Ariary",
                "MKD": "Macedonia Denar",
                "MMK": "Myanmar (Burma) Kyat",
                "MNT": "Mongolia Tughrik",
                "MOP": "Macau Pataca",
                "MRO": "Mauritania Ouguiya",
                "MUR": "Mauritius Rupee",
                "MVR": "Maldives (Maldive Islands) Rufiyaa",
                "MWK": "Malawi Kwacha",
                "MXN": "Mexico Peso",
                "MYR": "Malaysia Ringgit",
                "MZN": "Mozambique Metical",
                "NAD": "Namibia Dollar",
                "NGN": "Nigeria Naira",
                "NIO": "Nicaragua Cordoba",
                "NOK": "Norway Krone",
                "NPR": "Nepal Rupee",
                "NZD": "New Zealand Dollar",
                "OMR": "Oman Rial",
                "PAB": "Panama Balboa",
                "PEN": "Peru Nuevo Sol",
                "PGK": "Papua New Guinea Kina",
                "PHP": "Philippines Peso",
                "PKR": "Pakistan Rupee",
                "PLN": "Poland Zloty",
                "PYG": "Paraguay Guarani",
                "QAR": "Qatar Riyal",
                "RON": "Romania New Leu",
                "RSD": "Serbia Dinar",
                "RUB": "Russia Ruble",
                "RWF": "Rwanda Franc",
                "SAR": "Saudi Arabia Riyal",
                "SBD": "Solomon Islands Dollar",
                "SCR": "Seychelles Rupee",
                "SDG": "Sudan Pound",
                "SEK": "Sweden Krona",
                "SGD": "Singapore Dollar",
                "SHP": "Saint Helena Pound",
                "SLL": "Sierra Leone Leone",
                "SOS": "Somalia Shilling",
                "SPL": "Seborga Luigino",
                "SRD": "Suriname Dollar",
                "STD": "São Tomé and Príncipe Dobra",
                "SVC": "El Salvador Colon",
                "SYP": "Syria Pound",
                "SZL": "Swaziland Lilangeni",
                "THB": "Thailand Baht",
                "TJS": "Tajikistan Somoni",
                "TMT": "Turkmenistan Manat",
                "TND": "Tunisia Dinar",
                "TOP": "Tonga Pa'anga",
                "TRY": "Turkey Lira",
                "TTD": "Trinidad and Tobago Dollar",
                "TVD": "Tuvalu Dollar",
                "TWD": "Taiwan New Dollar",
                "TZS": "Tanzania Shilling",
                "UAH": "Ukraine Hryvna",
                "UGX": "Uganda Shilling",
                "USD": "United States Dollar",
                "UYU": "Uruguay Peso",
                "UZS": "Uzbekistan Som",
                "VEF": "Venezuela Bolivar",
                "VND": "Viet Nam Dong",
                "VUV": "Vanuatu Vatu",
                "WST": "Samoa Tala",
                "XAF": "Communauté Financière Africaine (BEAC) CFA Franc BEAC",
                "XCD": "East Caribbean Dollar",
                "XDR": "International Monetary Fund (IMF) Special Drawing Rights",
                "XOF": "Communauté Financière Africaine (BCEAO) Franc",
                "XPF": "Comptoirs Français du Pacifique (CFP) Franc",
                "YER": "Yemen Rial",
                "ZAR": "South Africa Rand",
                "ZMW": "Zambia Kwacha",
                "ZWL": "Zimbabwe Dollar"]
                
                return data
            }()
        }
        
        return Static.instance
    }
    
    private let square = 0x00B2;
    private let loading = "loading ..."
    
    var currentData = [String: [String]]()
    
    private let GDP_INDICATOR_STRING:String = "NY.GDP.MKTP.CD"
    private let GDP_PER_CAPITA_INDICATOR_STRING: String = "NY.GDP.PCAP.CD"
    private let GNI_PER_CAPITA_INDICATOR_STRING:String = "NY.GNP.PCAP.CD"
    private let dollar:UniChar = 0x0024
    private let TypeFloat:Int16 = 1
    private let StartYear:Int = 1970
    private var selectedYear: String!
    private var pickerViewData: [String]!
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.currentData[textLabelKey]!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? UITableViewCell
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: cellIdentifier)
        }
        
        return cell!
    }
    
    func setCountryData(country: CountryGeonames?) {
        self.country = country
    }
    
    func setAdministrationDataDefaults() {
        
        if let countryDetails = self.country {
            
            let surfaceString = numberFormatter.stringFromNumber(NSNumber(float: (countryDetails.areaInSqKm as NSString).floatValue))
            
            let administrationData = AdministrationData(capitalCity: countryDetails.capitalCity,
                                                            surface: String(format:"%@ km%C", surfaceString!, square),
                                                        currentTime: loading,
                                                           timeZone: loading,
                                                            sunrise: loading,
                                                             sunset: loading)
            
            self.currentData = administrationData.tr_tableRepresentation() as! [String: [String]]
        }
    }
    
    //MARK: PickerView functions
    
    func setupPickerViewData(completion: (() -> Void)?) {
        
        let year = NSDate().stringWithDateFormat("yyyy")
        
        let number: NSNumber = NSNumber(bool: true).numberFromStringWithStyle(year, style: NSNumberFormatterStyle.DecimalStyle)
        var yearsSpan = [String]()
        
        for iterator in stride(from:number.integerValue - 1, to:StartYear - 1, by:-1) {
            yearsSpan.append("\(iterator)")
        }
        
        self.selectedYear = yearsSpan[2]
        
        self.pickerViewData = yearsSpan
        
        if let block = completion {
            block()
        }
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerViewData.count
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerData() -> [String] {
        
        return self.pickerViewData
    }
    
    func setSelectedYear(year: String) {
        
        self.selectedYear = year
    }
    
    //MARK: Remote client functions
    
    private func getTimezone(latitude: Float, longitude: Float, completion: (NSError?) -> Void) {
        
        let url = String(format:"http://api.geonames.org/timezoneJSON?lat=%.2f&lng=%.2f&username=sbpuser", latitude, longitude)
        
        let operation = RKGeonamesUtils.setupObjectRequestOperation("timezoneMapping", withURL:url, pathPattern:nil, andKeyPath:nil)
        let surface = NSNumberFormatter.localizedStringFromNumber(NSNumber(float: (self.country!.areaInSqKm as NSString).floatValue), numberStyle: NSNumberFormatterStyle.DecimalStyle)

        var adminData = AdministrationData(capitalCity: self.country!.capitalCity, surface: surface, currentTime: loading, timeZone: loading, sunrise: loading, sunset: loading)
        
        RKGeonamesUtils.getDataWithOperation(operation, completion: { (results: [AnyObject]?, error: NSError?) -> Void in
            
            if let err = error {
                completion(error)
                
                return
            }
            
            let timezone = results!.first as! Timezone
            
            var formattedTimezone = "GMT\(timezone.gmtOffset!)"
            var offset = timezone.gmtOffset as NSString?
            if offset?.intValue >= 0 {
                formattedTimezone = "GMT+\(timezone.gmtOffset!)"
            }
            
            let timezoneAsString = "GMT\(formattedTimezone)"

            let adminData = AdministrationData(capitalCity:self.country!.capitalCity,
                                                surface:String(format: "%@ km%C", surface, self.square),
                                               currentTime:timezone.time!,
                                                  timeZone:formattedTimezone,
                                                   sunrise:timezone.sunrise!,
                                                    sunset:timezone.sunset!)
            
            self.currentData = adminData.tr_tableRepresentation() as! [String: [String]]
            
            completion(nil)
        })
    }
    
    func getAdministrationData(completion: (NSError?) -> Void) {
        
        if let countryData = self.country {
            let CITYURL = "http://api.geonames.org/citiesJSON?north=%@&south=%@&east=%@&west=%@&username=sbpuser"
            
            let url = String(format: CITYURL, countryData.north, countryData.south, countryData.east, countryData.west)
            
            let operation = RKGeonamesUtils.setupObjectRequestOperation("cityMapping", withURL: url, pathPattern: nil, andKeyPath: "geonames")
            let predicate = NSPredicate(format: "(%@ contains name) AND (countrycode == %@)", countryData.capitalCity, countryData.countryCode)
            
            RKGeonamesUtils.getDataWithOperation(operation, completion: { (results: [AnyObject]?, error: NSError?) -> Void in
                
                if let err = error {
                    
                    completion(error)
                    
                    return
                }
                
                let filteredItems = results!.filter() {
                    
                    let city: RKGCity! = ($0 as? RKGCity)
                    let capital:String = city.name as! String
                    let countryCode:String = city.countrycode as! String
                    
                    var isCapitalCity = false
                    if capital.rangeOfString(countryData.capitalCity) != nil {
                        isCapitalCity = true
                    }
                    
                    let isCountryCode = countryCode == countryData.countryCode
                    
                    return isCapitalCity && isCountryCode
                }
                    
                if filteredItems.count > 0 {
                    let city = filteredItems[0] as! RKGCity
                    
                    var latitude: Float = 0
                    if let lat = city.lat {
                        latitude = lat.floatValue
                    }
                    
                    var longitude: Float = 0
                    if let lng = city.lng {
                        longitude = lng.floatValue
                    }
                    
                    self.getTimezone(latitude, longitude: longitude, completion: { (error: NSError?) -> Void in
                        completion(error)
                    })
                }
                
            })
        }
    }
    
    func setDemographicDataDefaults() {
            
        var demographicData = DemographicData(totalPopulation: loading, populationGrowth: loading, birthRate: loading, deathRate: loading)
        
        self.currentData = demographicData.tr_tableRepresentation() as! [String: [String]]
    }

    func getDemographicData(completion : (NSError?) -> Void ) {
        let demographicsDataManager = RKDemographicDataManager(country: self.country, selectedYear: self.selectedYear)
        
        demographicsDataManager.retrieve( { (data: [String : [String]]?, error: NSError?) -> Void in
            
            self.currentData = data!
            completion(error)
        })

    }
    
    func setEconomicsDataDefaults() {

        var economicsData = EconomyData(currency: "", gdp: loading, gdppc: loading, gnipc: loading)
        if let country = self.country {
            let currency = self.currencies[country.currency]
            economicsData = EconomyData(currency: currency!, gdp: loading, gdppc: loading, gnipc: loading)
        }
        
        self.currentData = economicsData.tr_tableRepresentation() as! [String: [String]]
    }
    
    func getEconomicsData(completion: (NSError?) -> Void) {

        let economicsDataManager = RKEconomicsDataManager(country: self.country, selectedYear: self.selectedYear)
        
        economicsDataManager.retrieve( { (data: [String : [String]]?, error: NSError?) -> Void in
          
            self.currentData = data!
            completion(error)
        })
    }
    
    
    func countryDetails() -> [String: [String]] {
        
        return self.currentData
    }
}
