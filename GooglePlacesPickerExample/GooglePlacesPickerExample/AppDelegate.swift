//
//  AppDelegate.swift
//  GooglePlacesPickerExample
//
//  Created by Ihor Rapalyuk on 2/13/16.
//  Copyright © 2016 Ihor Rapalyuk. All rights reserved.
//

import UIKit
import GooglePlacesPicker

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        GooglePlaces.googlePlacesAPIKey = "AIzaSyBfCc-2bMadlggAkkNiCDa33PJFllID30Y"
        
        return true
    }

}

