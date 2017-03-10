//
//  GEOCountryDetailsViewModel.swift
//  RKGeonames
//
//  Created by Stefan Buretea on 1/18/17.
//  Copyright © 2017 Stefan Burettea. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift


class GEOCountryDetailsViewModel {
    let country: GEOCountry
    
    fileprivate enum Constants {
        static let StartYear:Int = 1970
    }
    
    init(country: GEOCountry) {
        self.country = country
    }
    
    func requestAdministrationData() -> Observable<[String: [String]]> {
        let adminstrationData = GEOCountryAdministrationData(country: country, year: "")
        return adminstrationData.retrieve()
                                .flatMapLatest({ record -> Observable<[String: [String]]> in
                                    var result:[String: [String]] = [:]
//                                    result["titles"] = Array(record.keys)
//                                    result["values"] = Array(record.values)
                                    
                                    return Observable.from(result)
                                })
    }
    
    var pickerViewData: [String] {
        return (Constants.StartYear...NSCalendar.current.component(.year, from: NSDate() as Date)).reversed().map { "\($0)" }
    }
    
    var initiallySelectedPickerViewYear: String {
        return "\(NSCalendar.current.component(.year, from: NSDate() as Date) - 3)"
    }
    
    var initiallySelectedPickerViewRow: Int {
        return 3
    }
}
