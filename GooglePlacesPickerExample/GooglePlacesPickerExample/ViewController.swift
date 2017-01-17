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
        
        self.googlePlaceTextField?.addTarget(self, action: #selector(ViewController.googlePlaceTextFieldDidBeginEditing), for: .editingDidBegin)
    }
    
    func googlePlaceTextFieldDidBeginEditing() {
        let alert = GooglePlacePickerViewController()
        alert.delegate = self
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: GooglePlacePickerViewControllerDelegate
    
    func googlePlacePicker(_ googlePlacePickerViewController: GooglePlacePickerViewController,
        didSelectGooglePlace googlePlace: GooglePlace) {
            self.googlePlaceTextField?.text = googlePlace.description
            self.dismissGooglePlacesPicker()
    }
    
    func googlePlacePickerViewControllerDidPressCancelButton(_ googlePlacePickerViewController: GooglePlacePickerViewController) {
        self.dismissGooglePlacesPicker()
    }
    
    private func dismissGooglePlacesPicker() {
        self.googlePlaceTextField?.isEnabled = true
        self.dismiss(animated: true, completion: nil)
    }
}

