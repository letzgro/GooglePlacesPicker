//
//  GooglePlaces.swift
//
//  Created by Ihor Rapalyuk on 2/3/16.
//  Copyright © 2016 Lezgro. All rights reserved.
//

import Foundation

public class GooglePlaces {

    public static var googlePlacesAPIKey = ""
    
    func googlePlacesByKeyWord(keyWord: String) -> NSDictionary {
        if let keyWordProsecced = keyWord.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet()),
            url = NSURL(string: "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=\(keyWordProsecced)&key=\(GooglePlaces.googlePlacesAPIKey)") {
            if let json = NSData(contentsOfURL: url),
                data = self.parseData(json) {
                return data
            }
        }
        return [:]
    }

    private func parseData(data: NSData) -> NSDictionary? {
        return (try? NSJSONSerialization.JSONObjectWithData(data,
            options: NSJSONReadingOptions.MutableContainers) as? NSDictionary) ?? nil
    }
}