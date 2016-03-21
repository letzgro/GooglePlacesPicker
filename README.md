# GooglePlacesPicker
Swift IOS Pod. GooglePlacesPicker lets a user select an Google Places.

Import:

        import GooglePlacesPicker

Cocoapods:

        pod 'GooglePlacesPicker'

1) You need to set up your API KEY like this 

        GooglePlaces.googlePlacesAPIKey = "[KEY]"

2) Implement GooglePlacePickerViewControllerDelegate Methods which you need

        func googlePlacePicker(googlePlacePickerViewController: GooglePlacePickerViewController, didSelectGooglePlace googlePlace: GooglePlace)
  
        func googlePlacePickerViewControllerDidPressCancelButton(googlePlacePickerViewController: GooglePlacePickerViewController)
    
3) Show GooglePlacesPicker

        let alert = GooglePlacePickerViewController()
        alert.delegate = self
        self.presentViewController(alert, animated: true, completion: nil)
        
<img src="https://raw.githubusercontent.com/letzgro/GooglePlacesPicker/master/GooglePlacesPickerExample.gif" alt="alt text" width= "200px" align="center">

To customize Picker simply inherite from GooglePlacePickerViewController and override updateUI method like this:

        import GooglePlacesPicker
        class TestGooglePlacePickerViewController: GooglePlacePickerViewController {
            
            override func updateUI() {
                super.updateUI()
                self.leftBarButtonItem?.tintColor = UIColor.blackColor()
                self.rightBarButtonItem?.tintColor = UIColor.blackColor()
                self.navigationBar?.barTintColor = UIColor.redColor()
            }
        }

Example Project https://github.com/letzgro/GooglePlacesPicker/tree/master/GooglePlacesPickerExample 


