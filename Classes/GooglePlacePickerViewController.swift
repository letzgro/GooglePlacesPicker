//
//  AlertSelectPlaceController.swift
//
//  Created by Ihor Rapalyuk on 2/3/16.
//  Copyright © 2016 Lezgro. All rights reserved.
//

import UIKit

public protocol GooglePlacePickerViewControllerDelegate {
    
    func googlePlacePicker(googlePlacePickerViewController: GooglePlacePickerViewController, didSelectGooglePlace googlePlace: GooglePlace)
    func googlePlacePickerViewControllerDidPressCancelButton(googlePlacePickerViewController: GooglePlacePickerViewController)
}

extension GooglePlacePickerViewControllerDelegate {
    
    func googlePlacePicker(googlePlacePickerViewController: GooglePlacePickerViewController,
        didSelectGooglePlace googlePlace: GooglePlace) {}
    func googlePlacePickerViewControllerDidPressCancelButton(googlePlacePickerViewController: GooglePlacePickerViewController) {}
}

public class GooglePlacePickerViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    @IBOutlet public weak var placeTextField: UITextField?
    @IBOutlet public weak var placesTableView: UITableView?
    @IBOutlet public weak var placesIconImageView: UIImageView?
    @IBOutlet public weak var navigationBar: UINavigationBar?
    @IBOutlet public weak var leftBarButtonItem: UIBarButtonItem?
    @IBOutlet public weak var rightBarButtonItem: UIBarButtonItem?
    
    public var placeIconChoosed: UIImage?
    public var placeIconNotChoosed: UIImage?
    
    private let googlePlacesCellIdentifier = "GooglePlacesCellIdentifier"
    private let googlePlacesNibNameIdentifier = "GooglePlacesCell"
    private let googlePlacePickerViewControllerNibNameIdentifier = "GooglePlacePickerViewController"
    
    public var navigationBarColor: UIColor = UIColor(red: 104/255, green: 203/255, blue: 223/255, alpha: 1.0)
    
    public var autocompletePlaces: [GooglePlace] = []
    
    public var delegate: GooglePlacePickerViewControllerDelegate?
    
    var googlePlacesReciever = GooglePlacesReciever()
    
    public var selectedGooglePlace: GooglePlace?
    
    private let currentBoundle: NSBundle
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.placeTextField?.becomeFirstResponder()
        self.placeTextField?.addTarget(self, action: "placeTextFieldDidChange", forControlEvents: .EditingChanged)
        self.placesTableView?.registerNib(UINib(nibName: self.googlePlacesNibNameIdentifier, bundle: self.currentBoundle),
            forCellReuseIdentifier: self.googlePlacesCellIdentifier)
        self.updateUI()
    }
    
    public func updateUI() {
        self.view.layer.cornerRadius = 4
        self.placeIconChoosed = UIImage(named: "place_icon_choosed", inBundle: self.currentBoundle, compatibleWithTraitCollection: nil)
        self.placeIconNotChoosed = UIImage(named: "place_icon_notChoosed", inBundle: self.currentBoundle, compatibleWithTraitCollection: nil)
        self.placesIconImageView?.image = self.placeIconNotChoosed
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.currentBoundle = NSBundle(forClass: GooglePlacePickerViewController.self)
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    override public init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!)  {
        self.currentBoundle = NSBundle(forClass: GooglePlacePickerViewController.self)
        super.init(nibName: self.googlePlacePickerViewControllerNibNameIdentifier, bundle: self.currentBoundle)
        self.commonInit()
    }
    
    private func commonInit() {
        self.modalPresentationStyle = .Custom
        self.transitioningDelegate = self
    }
    
    func placeTextFieldDidChange() {
        self.checkMaxLength(self.placeTextField, maxLength: 200)
        self.initList()
    }
    
    private func checkMaxLength(textField: UITextField!, maxLength: Int) {
        if (textField.text?.characters.count > maxLength) {
            textField.deleteBackward()
        }
    }
    
    //MARK UIViewControllerTransitioningDelegate methods
    
    public func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        if presented == self {
            return GooglePlacesPresentationController(presentedViewController: presented, presentingViewController: presenting)
        }
        return nil
    }
    
    public func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if presented == self {
            return GooglePlacesPresentationAnimationController(isPresenting: true)
        } else {
            return nil
        }
    }
    
    public func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if dismissed == self {
            return GooglePlacesPresentationAnimationController(isPresenting: false)
        } else {
            return nil
        }
    }
    
    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
        self.delegate?.googlePlacePickerViewControllerDidPressCancelButton(self)
    }
    
    @IBAction func saveButtonPressed(sender: UIBarButtonItem) {
        if let selectedGooglePlace = self.selectedGooglePlace {
            self.delegate?.googlePlacePicker(self, didSelectGooglePlace: selectedGooglePlace)
        }
    }
    
    private func initList() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            if let txtPlaceText = self.placeTextField?.text {
                let googlePlaces = self.googlePlacesReciever.googlePlacesByKeyWord(txtPlaceText)
                if let predictions = googlePlaces.valueForKey("predictions") as? [AnyObject] {
                    self.autocompletePlaces = predictions.flatMap{
                        if let description = $0.valueForKey("description") as? String,
                            placeId = $0.valueForKey("place_id") as? String {
                                return GooglePlace(placeId: placeId, description: description)
                        }
                        return nil
                    }
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.placesTableView?.reloadData()
                    }
                }
            }
        }
    }
    
    // MARK: - Table view data source
    func tableView(tableView: UITableView?, didSelectRowAtIndexPath indexPath: NSIndexPath?) {
        if let indexPath = indexPath {
            self.placeTextField?.text = getPlaceName(indexPath.row)
            self.placesIconImageView?.image = self.placeIconChoosed
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.autocompletePlaces.count
    }
    
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier(self.googlePlacesCellIdentifier,
                forIndexPath: indexPath)
            self.selectedGooglePlace = self.autocompletePlaces[indexPath.row]
            cell.textLabel?.text = getPlaceName(indexPath.row)
            return cell
    }
    
    func getPlaceName(indexPath: Int) -> String {
        if let item =  self.autocompletePlaces[indexPath].description {
            if let index = item.rangeOfString(",")?.startIndex {
                return item.substringToIndex(index)
            }
            return item
        }
        return ""
    }
}