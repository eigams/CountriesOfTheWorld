//
//  EconomicsDataManager.swift
//  RKGeonames
//
//  Created by Stefan Buretea on 4/6/15.
//  Copyright (c) 2015 Stefan Burettea. All rights reserved.
//

import UIKit

class RKEconomicsDataManager: NSObject {
   
    private var currencies: [String: String] {
        
        struct Static {
            static let instance: [String: String] = {
                
                let data = ["AED": "UAE Dirham",
                    "AFN": "Afghanistan Afghani",
                    "ALL": "Albania Lek",
                    "AMD": "Armenia Dram",
                    "ANG": "Antilles Guilder",
                    "AOA": "Angola Kwanza",
                    "ARS": "Argentina Peso",
                    "AUD": "Australia Dollar",
                    "AWG": "Aruba Guilder",
                    "AZN": "Azerbaijan New Manat",
                    "BAM": "Convertible Marka",
                    "BBD": "Barbados Dollar",
                    "BDT": "Bangladesh Taka",
                    "BGN": "Bulgaria Lev",
                    "BHD": "Bahrain Dinar",
                    "BIF": "Burundi Franc",
                    "BMD": "Bermuda Dollar",
                    "BND": "Brunei Dollar",
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
                    "EUR": "Euro",
                    "FJD": "Fiji Dollar",
                    "FKP": "(Malvinas) Pound",
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
                    "MVR": "Maldives Rufiyaa",
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
                    "XAF": "BEAC CFA Franc BEAC",
                    "XCD": "East Caribbean Dollar",
                    "XDR": "IMF Special Drawing Rights",
                    "XOF": "BCEAO Franc",
                    "XPF": "CFP Franc",
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
    
    var GDP: String = "loading ..."
    var GDPPerCapita: String = "loading ..."
    var GNIPerCapita: String = "loading ..."
    
    private let GDP_INDICATOR_STRING:String = "NY.GDP.MKTP.CD"
    private let GDP_PER_CAPITA_INDICATOR_STRING: String = "NY.GDP.PCAP.CD"
    private let GNI_PER_CAPITA_INDICATOR_STRING:String = "NY.GNP.PCAP.CD"
    private let dollar:UniChar = 0x0024
    private let TypeFloat:Int16 = 1
    
    private let country: CountryGeonames!
    private let selectedYear: String!
    
    init(country: CountryGeonames!, selectedYear: String!) {
        
        self.country = country
        self.selectedYear = selectedYear
    }
    
    func retrieve(completion: ([String: [String]]?, NSError?) -> Void) {
        
        let bankIndicatorsData = [GDP_INDICATOR_STRING: ["GDP", "gdp"],
            GDP_PER_CAPITA_INDICATOR_STRING: ["GDPPerCapita", "gdppercapita"],
            GNI_PER_CAPITA_INDICATOR_STRING: ["GNIPerCapita", "gnipercapita"]]
        
        var results = EconomyData(currency: currencies[self.country.currency]!, gdp: GDP, gdppc:GDPPerCapita, gnipc:GNIPerCapita)
        var data = results.tr_tableRepresentation() as! [String: [String]]
        
        completion(data, nil)
        
        for (key, value) in bankIndicatorsData {
            
            self.getIndicatorData(key, completion: { (data: String?, error: NSError?) -> Void in
                
                if nil != error {
                    completion(nil, error)
                    
                    return
                }
                
                self.setValue(data, forKey: value.first!)
                
                results = EconomyData(currency: self.currencies[self.country.currency]!, gdp: self.GDP, gdppc:self.GDPPerCapita, gnipc:self.GNIPerCapita)
                var data = results.tr_tableRepresentation() as! [String: [String]]
                
                completion(data, nil)
            })
        }
        
        self.GDP = loading
        self.GDPPerCapita = loading
        self.GNIPerCapita = loading
    }
    
    private func getIndicatorData(indicator: String, completion: (String?, NSError?) -> Void) {
        
        RKGeonamesUtils.fetchWorldBankIndicator(indicator, countryCode: self.country?.countryCode, year: self.selectedYear != nil ? self.selectedYear : "2011", type: 1, text: String(format: " %C", dollar), completion: { (data: String?, error: NSError?) -> Void in
            completion(data, error)
        })
        
    }
    
    
}
