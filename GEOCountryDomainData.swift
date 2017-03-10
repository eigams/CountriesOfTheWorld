//
//  GEOCountryDomainData.swift
//  RKGeonames
//
//  Created by Stefan Buretea on 1/17/17.
//  Copyright © 2017 Stefan Burettea. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxDataSources


struct GEOCountryDomainDataItem {
    var title: String
    var value: String
}

struct GEOSectionOfCountryDomainDataItem {
    var header: String
    var items: [Item]
}

extension GEOSectionOfCountryDomainDataItem: SectionModelType {
    typealias Item = GEOCountryDomainDataItem
    
    init(original: GEOSectionOfCountryDomainDataItem, items: [Item]) {
        self = original
        self.items = items
    }
}


protocol GEOCountryDomainData {
    var country: GEOCountry { get }
    var year: String { get }
    
    init(country: GEOCountry, year: String)    
    func retrieve() -> Observable<[GEOCountryDomainDataItem]>
}

enum GEOCountryDomainDataType {
    case administration(GEOCountry, String)
    case demographic(GEOCountry, String)
    case economic(GEOCountry, String)
}

enum GEOCountryDomainDataFactory {
    static func domainData(for type: GEOCountryDomainDataType) -> GEOCountryDomainData {
        switch type {
            case .administration(let country, let year):
                return GEOCountryAdministrationData(country: country, year: year)
            case .demographic(let country, let year):
                return GEOCountryDemographicData(country: country, year: year)
            case .economic(let country, let year):
                return GEOCountryEconomicData(country: country, year: year)
        }
    }
}
