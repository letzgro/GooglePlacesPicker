//
//  GooglePlaces.swift
//
//  Created by Ihor Rapalyuk on 2/3/16.
//  Copyright © 2016 Lezgro. All rights reserved.
//

import Foundation

open class GooglePlacesReciever {

    open static var googlePlacesAPIKey = ""
    
    func googlePlacesByKeyWord(_ keyWord: String) -> NSDictionary {
        if let keyWordProsecced = keyWord.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
            let url = URL(string: "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=\(keyWordProsecced)&key=\(GooglePlacesReciever.googlePlacesAPIKey)") {
            if let json = try? Data(contentsOf: url),
                let data = self.parseData(json) {
                return data
            }
        }
        return [:]
    }

    fileprivate func parseData(_ data: Data) -> NSDictionary? {
        return (try? JSONSerialization.jsonObject(with: data,
            options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary) ?? nil
    }
}
