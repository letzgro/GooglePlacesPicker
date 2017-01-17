//
//  AlertSelectPlaceController.swift
//
//  Created by Ihor Rapalyuk on 2/3/16.
//  Copyright © 2016 Lezgro. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


public protocol GooglePlacePickerViewControllerDelegate {
    
    func googlePlacePicker(_ googlePlacePickerViewController: GooglePlacePickerViewController, didSelectGooglePlace googlePlace: GooglePlace)
    func googlePlacePickerViewControllerDidPressCancelButton(_ googlePlacePickerViewController: GooglePlacePickerViewController)
}

extension GooglePlacePickerViewControllerDelegate {
    
    func googlePlacePicker(_ googlePlacePickerViewController: GooglePlacePickerViewController,
        didSelectGooglePlace googlePlace: GooglePlace) {}
    func googlePlacePickerViewControllerDidPressCancelButton(_ googlePlacePickerViewController: GooglePlacePickerViewController) {}
}

open class GooglePlacePickerViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    @IBOutlet open weak var placeTextField: UITextField?
    @IBOutlet open weak var placesTableView: UITableView?
    @IBOutlet open weak var placesIconImageView: UIImageView?
    @IBOutlet open weak var navigationBar: UINavigationBar?
    @IBOutlet open weak var leftBarButtonItem: UIBarButtonItem?
    @IBOutlet open weak var rightBarButtonItem: UIBarButtonItem?
    
    open var placeIconChoosed: UIImage?
    open var placeIconNotChoosed: UIImage?
    
    fileprivate let googlePlacesCellIdentifier = "GooglePlacesCellIdentifier"
    fileprivate let googlePlacesNibNameIdentifier = "GooglePlacesCell"
    fileprivate let googlePlacePickerViewControllerNibNameIdentifier = "GooglePlacePickerViewController"
    
    open var navigationBarColor: UIColor = UIColor(red: 104/255, green: 203/255, blue: 223/255, alpha: 1.0)
    
    open var autocompletePlaces: [GooglePlace] = []
    
    open var delegate: GooglePlacePickerViewControllerDelegate?
    
    var googlePlacesReciever = GooglePlacesReciever()
    
    open var selectedGooglePlace: GooglePlace?
    
    fileprivate let currentBoundle: Bundle
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.placeTextField?.becomeFirstResponder()
        self.placeTextField?.addTarget(self, action: #selector(GooglePlacePickerViewController.placeTextFieldDidChange), for: .editingChanged)
        self.placesTableView?.register(UINib(nibName: self.googlePlacesNibNameIdentifier, bundle: self.currentBoundle),
            forCellReuseIdentifier: self.googlePlacesCellIdentifier)
        self.updateUI()
    }
    
    open func updateUI() {
        self.view.layer.cornerRadius = 4
        self.placeIconChoosed = UIImage(named: "place_icon_choosed", in: self.currentBoundle, compatibleWith: nil)
        self.placeIconNotChoosed = UIImage(named: "place_icon_notChoosed", in: self.currentBoundle, compatibleWith: nil)
        self.placesIconImageView?.image = self.placeIconNotChoosed
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.currentBoundle = Bundle(for: GooglePlacePickerViewController.self)
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    override public init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!)  {
        self.currentBoundle = Bundle(for: GooglePlacePickerViewController.self)
        super.init(nibName: self.googlePlacePickerViewControllerNibNameIdentifier, bundle: self.currentBoundle)
        self.commonInit()
    }
    
    fileprivate func commonInit() {
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self
    }
    
    func placeTextFieldDidChange() {
        self.checkMaxLength(self.placeTextField, maxLength: 200)
        self.initList()
    }
    
    fileprivate func checkMaxLength(_ textField: UITextField!, maxLength: Int) {
        if (textField.text?.characters.count > maxLength) {
            textField.deleteBackward()
        }
    }
    
    //MARK UIViewControllerTransitioningDelegate methods
    
    open func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        if presented == self {
            return GooglePlacesPresentationController(presentedViewController: presented, presenting: presenting)
        }
        return nil
    }
    
    open func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if presented == self {
            return GooglePlacesPresentationAnimationController(isPresenting: true)
        } else {
            return nil
        }
    }
    
    open func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if dismissed == self {
            return GooglePlacesPresentationAnimationController(isPresenting: false)
        } else {
            return nil
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        self.delegate?.googlePlacePickerViewControllerDidPressCancelButton(self)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        if let selectedGooglePlace = self.selectedGooglePlace {
            self.delegate?.googlePlacePicker(self, didSelectGooglePlace: selectedGooglePlace)
        }
    }
    
    fileprivate func initList() {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            if let txtPlaceText = self.placeTextField?.text {
                let googlePlaces = self.googlePlacesReciever.googlePlacesByKeyWord(txtPlaceText)
                if let predictions = googlePlaces.value(forKey: "predictions") as? [AnyObject] {
                    self.autocompletePlaces = predictions.flatMap{
                        if let description = $0.value(forKey: "description") as? String,
                            let placeId = $0.value(forKey: "place_id") as? String {
                                return GooglePlace(placeId: placeId, description: description)
                        }
                        return nil
                    }
                    
                    DispatchQueue.main.async {
                        self.placesTableView?.reloadData()
                    }
                }
            }
        }
    }
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView?, didSelectRowAtIndexPath indexPath: IndexPath?) {
        if let indexPath = indexPath {
            self.placeTextField?.text = getPlaceName((indexPath as NSIndexPath).row)
            self.placesIconImageView?.image = self.placeIconChoosed
        }
    }
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.autocompletePlaces.count
    }
    
    func tableView(_ tableView: UITableView,
        cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: self.googlePlacesCellIdentifier,
                for: indexPath)
            self.selectedGooglePlace = self.autocompletePlaces[(indexPath as NSIndexPath).row]
            cell.textLabel?.text = getPlaceName((indexPath as NSIndexPath).row)
            return cell
    }
    
    func getPlaceName(_ indexPath: Int) -> String {
        if let item =  self.autocompletePlaces[indexPath].description {
            if let index = item.range(of: ",")?.lowerBound {
                return item.substring(to: index)
            }
            return item
        }
        return ""
    }
}
