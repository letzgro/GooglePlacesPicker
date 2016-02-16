//
//  ViewController.swift
//  GooglePlacesPickerExample
//
//  Created by Ihor Rapalyuk on 2/13/16.
//  Copyright © 2016 Ihor Rapalyuk. All rights reserved.
//

import UIKit
import GooglePlacesPicker

class ViewController: UIViewController, GooglePlacePickerViewControllerDelegate {

    @IBOutlet private var googlePlaceTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.googlePlaceTextField?.addTarget(self, action: "googlePlaceTextFieldDidBeginEditing", forControlEvents: .EditingDidBegin)
    }
    
    func googlePlaceTextFieldDidBeginEditing() {
        let alert = GooglePlacePickerViewController()
        alert.delegate = self
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    //MARK: GooglePlacePickerViewControllerDelegate
    
    func googlePlacePicker(googlePlacePickerViewController: GooglePlacePickerViewController,
        didSelectGooglePlace googlePlace: GooglePlace) {
            self.googlePlaceTextField?.text = googlePlace.description
            self.dismissGooglePlacesPicker()
    }
    
    func googlePlacePickerViewControllerDidPressCancelButton(googlePlacePickerViewController: GooglePlacePickerViewController) {
        self.dismissGooglePlacesPicker()
    }
    
    private func dismissGooglePlacesPicker() {
        self.googlePlaceTextField?.enabled = true
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

