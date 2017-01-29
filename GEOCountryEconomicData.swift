//
//  GEOCountryEconomicData.swift
//  RKGeonames
//
//  Created by Stefan Buretea on 1/17/17.
//  Copyright © 2017 Stefan Burettea. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift


class GEOCountryEconomicData: GEOCountryDomainData {
    let country: GEOCountry
    let year: String
    
    typealias IndicatorConfig = (section: String, additionalText: String, initialText: String)
    
    fileprivate enum Indicator:String {
        case gdp = "NY.GDP.MKTP.CD"
        case gdpPerCapita = "NY.GDP.PCAP.CD"
        case gniPerCapita = "NY.GNP.PCAP.CD"
        
        var config: IndicatorConfig {
            switch self {
            case .gdp:
                return (section: "GDP", additionalText: "$", initialText: "N/A")
            case .gdpPerCapita:
                return (section: "GDP per Capita", additionalText: "$", initialText: "N/A")
            case .gniPerCapita:
                return (section: "GNI per Capita", additionalText: "$", initialText: "N/A")
            }
        }
    }
    
    
    fileprivate struct Constants {
        static let Indicators:[Indicator] = [.gdp, .gdpPerCapita, .gniPerCapita]
        
        static let currencySectionName = "CURRENCY"
        static let PerMilleCharCode:UniChar = 0x2030
    }
    
    required init(country: GEOCountry, year: String) {
        self.country = country
        self.year = year
    }
    
    func retrieve() -> Observable<[GEOCountryDomainDataItem]> {
        var result = Constants.Indicators.map { [unowned self] indicator -> Observable<GEOCountryDomainDataItem> in
            guard let request = GEOWorldBankIndicatorRequest(countryCode: self.country.countryCode ?? "", indicator: indicator.rawValue, startYear: self.year, endYear: self.year) else { return Observable.empty() }
            
            let section = indicator.config.section
            return GEOHTTPClient.requestWorldBankIndicator(with: request)
                .flatMap({ indicator -> Observable<GEOCountryDomainDataItem> in
                    if let value = indicator.value,
                        let float = Float(value) {
                        let number = NSNumber(value: float)
                        
                        return Observable.just(GEOCountryDomainDataItem(title: section, value: "\(NumberFormatter.localizedString(from: number, number: .decimal)) $"))
                    }
                    
                    return Observable.empty()
                })
        }
        
        result.append(Observable.just(GEOCountryDomainDataItem(title: Constants.currencySectionName, value: GEOCurrencies.sharedInstance[country.currencyCode ?? ""])))
        return Observable.from(result).merge().toArray()
    }
}
