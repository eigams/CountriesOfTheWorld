//
//  GEOCountryAdministrationData.swift
//  RKGeonames
//
//  Created by Stefan Buretea on 1/17/17.
//  Copyright © 2017 Stefan Burettea. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift


class GEOCountryAdministrationData: GEOCountryDomainData {
    let country: GEOCountry
    let year: String
    
    fileprivate struct Constants {        
        struct Sections {
            static let CapitalCity = "CAPITAL CITY"
            static let Surface = "SURFACE"
            static let CurrentTime = "CURRENT TIME"
            static let TimeZone = "TIMEZONE"
            static let Sunrise = "SUNRISE"
            static let Sunset = "SUNSET"
        }
        
        static let square = 0x00B2;
    }
    
    required init(country: GEOCountry, year: String) {
        self.country = country
        self.year = year
    }
    
    func retrieve() -> Observable<[GEOCountryDomainDataItem]> {
        var result:[GEOCountryDomainDataItem] = []
        result.append(GEOCountryDomainDataItem(title: Constants.Sections.CapitalCity, value: country.capitalCity ?? ""))
        result.append(GEOCountryDomainDataItem(title: Constants.Sections.Surface, value: String(format:"%@ km%C", country.surfaceArea, Constants.square)))
        
        let cityRequest = GEOCapitalCityRequest(country: country)
        return GEOHTTPClient.requestCityData(with: cityRequest)
            .map { cities in
                return cities.index(where: { city in
                    guard let cityCountryCode = city.countrycode, let name = city.name,
                        let countryCapitalCity = self.country.capitalCity,
                        let countryCode = self.country.countryCode else { return false }
                    
                    return name == countryCapitalCity && cityCountryCode == countryCode
                }).map { cities[$0] }
            }
            .flatMapLatest { city -> Observable<GEOTimezone> in
                guard let latitude = city?.lat, let longitude = city?.lng else { return Observable.empty() }
                guard let timezoneRequest = GEOTimezoneRequest(latitude: "\(latitude)", longitude: "\(longitude)") else { return Observable.empty() }
                
                return GEOHTTPClient.requestTimezone(with: timezoneRequest)
            }
            .flatMapLatest { timezone -> Observable<[GEOCountryDomainDataItem]> in
                result.append(GEOCountryDomainDataItem(title: Constants.Sections.CurrentTime, value: timezone.time ?? ""))
                result.append(GEOCountryDomainDataItem(title: Constants.Sections.TimeZone, value: timezone.asString))
                result.append(GEOCountryDomainDataItem(title: Constants.Sections.Sunset, value: timezone.sunset ?? ""))
                result.append(GEOCountryDomainDataItem(title: Constants.Sections.Sunrise, value: timezone.sunrise ?? ""))
                
                return Observable.just(result)
            }
    }
}
