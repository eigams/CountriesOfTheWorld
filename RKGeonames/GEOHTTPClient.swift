//
//  GEOHTTPClient.swift
//  RKGeonames
//
//  Created by Stefan Buretea on 1/16/17.
//  Copyright © 2017 Stefan Burettea. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import RxCocoa
import RxSwift

class GEOHTTPClient {
    static let sharedInstance = GEOHTTPClient()
    
    fileprivate struct Constants {
        static let RequestCountriesURL = "http://api.geonames.org/countryInfoJSON?username=sbpuser"
    }
    
    internal required init() {}
    
    static func requestCountries() -> Observable<[GEOCountry]> {
        return Observable.create { observer in
            let requestRef = Alamofire.request(Constants.RequestCountriesURL).responseObject{ (response: DataResponse<GEOCountryHTTPResponse>) in
                if let value = response.result.value,
                    let items = value.geonames {
                    
                    observer.on(.next(items))
                    observer.on(.completed)
                } else if let error = response.result.error {
                    observer.onError(error)
                }
            }
            
            return Disposables.create(with: { requestRef.cancel() })
        }
    }
    
    static func requestWorldBankIndicator(with request: GEOWorldBankIndicatorRequest) -> Observable<GEOWorldBankIndicator> {
        return Observable.create{ observer in
            let requestRef = Alamofire.request(request.url).responseJSON { response in
                if let value = response.result.value as? [Any],
                    let data = value[1] as? [Any],
                    let jsonObject = data.first as? [String: Any],
                    let indicator = GEOWorldBankIndicator(JSON: jsonObject) {
                    
                    observer.on(.next(indicator))
                    observer.on(.completed)
                } else if let error = response.result.error {
                    observer.onError(error)
                }
            }
            
            return Disposables.create(with: { requestRef.cancel() })
        }
    }
    
    static func requestCityData(with request: GEOCapitalCityRequest) -> Observable<[GEOCity]> {
        return Observable.create{ observer in
            let requestRef = Alamofire.request(request.url).responseObject{ (response: DataResponse<GEOCityHTTPResponse>) in
                if let value = response.result.value,
                    let items = value.geonames {
                    
                    observer.on(.next(items))
                    observer.on(.completed)
                } else if let error = response.result.error {
                    observer.onError(error)
                }
            }
            
            return Disposables.create(with: { requestRef.cancel() })
        }
    }

    static func requestTimezone(with request: GEOTimezoneRequest) -> Observable<GEOTimezone> {
        return Observable.create{ observer in
            let requestRef = Alamofire.request(request.url).responseObject{ (response: DataResponse<GEOTimezone>) in
                if let value = response.result.value {
                    
                    observer.on(.next(value))
                    observer.on(.completed)
                } else if let error = response.result.error {
                    observer.onError(error)
                }
            }
            
            return Disposables.create(with: { requestRef.cancel() })
        }
    }
    
    static func requestCountryFlag(with request: GEOCountryFlagRequest) -> Observable<(String, UIImage)> {
        return Observable.create{ observer in
            let requestRef = Alamofire.request(request.url).responseData { response in
                if let value = response.result.value {
                    if let countryCode = request.country.countryCode,
                        let image = UIImage(data: value) {
                        observer.on(.next((countryCode, image)))
                    }
                    observer.on(.completed)
                } else if let error = response.result.error {
                    observer.onError(error)
                }
            }
            
            return Disposables.create(with: { requestRef.cancel() })
        }
    }
    
}
