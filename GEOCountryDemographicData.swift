//
//  GEOCountryDemographicData.swift
//  RKGeonames
//
//  Created by Stefan Buretea on 1/17/17.
//  Copyright © 2017 Stefan Burettea. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift


class GEOCountryDemographicData: GEOCountryDomainData {
    let country: GEOCountry
    let year: String
    
    typealias IndicatorConfig = (section: String, additionalText: String, initialText: String)
    
    fileprivate enum Indicator:String {
        case totalPopulation = "SP.POP.TOTL"
        case populationGrowth = "SP.POP.GROW"
        case birthRate = "SP.DYN.CBRT.IN"
        case deathRate =  "SP.DYN.CDRT.IN"
        
        var config: IndicatorConfig {
            switch self {
                case .totalPopulation:
                    return (section: "TOTAL POPULATION", additionalText: "", initialText: "N/A")
                case .populationGrowth:
                    return (section: "POPULATION GROWTH", additionalText: "%", initialText: "N/A")
                case .birthRate:
                    return (section: "BIRTH RATE", additionalText: String(format:"%C", Constants.PerMilleCharCode), initialText: "N/A")
                case .deathRate:
                    return (section: "TOTAL POPULATION", additionalText: String(format:"%C", Constants.PerMilleCharCode), initialText: "N/A")
            }
        }
    }
    
    fileprivate struct Constants {
        static let Indicators:[Indicator] = [.totalPopulation, .populationGrowth, .birthRate, .deathRate]
        static let PerMilleCharCode:UniChar = 0x2030
    }
    
    required init(country: GEOCountry, year: String) {
        self.country = country
        self.year = year
    }
    
    func retrieve() -> Observable<[GEOCountryDomainDataItem]> {
        let result = Constants.Indicators.map { [unowned self] indicator -> Observable<GEOCountryDomainDataItem> in
            guard let request = GEOWorldBankIndicatorRequest(countryCode: self.country.countryCode ?? "", indicator: indicator.rawValue, startYear: self.year, endYear: self.year) else { return Observable.empty() }
            
            let section = indicator.config.section
            let additionalText = indicator.config.additionalText
            return GEOHTTPClient.requestWorldBankIndicator(with: request)
                                .flatMapLatest({ indicator -> Observable<GEOCountryDomainDataItem> in
                                    guard let value = indicator.value, let float = Float(value) else { return Observable.empty() }
                                    
                                    let number = NSNumber(value: float)
                                    let item = GEOCountryDomainDataItem(title: section, value: "\(NumberFormatter.localizedString(from: number, number: .decimal))\(additionalText)")
                                    return Observable.just(item)
                                })
        }

        return Observable.from(result).merge().toArray()
    }
}

