//
//  PostingViewController.swift
//  OnTheMap
//
//  Created by Kenneth Chen on 9/29/17.
//  Copyright © 2017 Cotery. All rights reserved.
//

import UIKit
import MapKit

class PostingViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animateActivityIndicator(animated: false)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tap(gesture:)))
        view.addGestureRecognizer(tapGesture)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Add Location"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonPressed))
    }
    
    @IBAction func findLocationButtonPressed(_ sender: Any) {
        if locationTextField.text!.isEmpty || urlTextField.text!.isEmpty {
            displayAlert(errorString: "Location or website is empty.")
        } else if urlTextField.text!.prefix(8) != "https://" {
            displayAlert(errorString: "Please enter url, starting with 'https://'")
        } else {
            animateActivityIndicator(animated: true)
            MyLocation.address = self.locationTextField.text!
            MyLocation.url = self.urlTextField.text!
            getMyLocation(completionHandler: { (success, errorString) in
                if (success) {
                    print("Successfully set your location data")

                    let controller = self.storyboard!.instantiateViewController(withIdentifier: "PostingConfirmViewController") as! PostingConfirmViewController
                    self.navigationController!.pushViewController(controller, animated: true)
                    
                    self.animateActivityIndicator(animated: false)
                } else {
                    
                    performUIUpdatesOnMain {
//                        self.setUIEnabled(false)
                        self.displayAlert(errorString: errorString!)
//                        self.setUIEnabled(true)
                        self.animateActivityIndicator(animated: false)
                    }
                }
            })
        }
    }
    
    @IBAction func urlTextFieldBeginEditing(_ sender: Any) {
            self.urlTextField.text = "https://"
    }
    
    func getMyLocation(completionHandler: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(locationTextField.text!) { (placemark, error) in
            performUIUpdatesOnMain {
                if let error = error {
                    print("Could not geocode the entered location: \(error)")
                    completionHandler(false, error.localizedDescription)
                    return
                }
                
                guard let placemark = placemark else {
                    print("No placemarks found")
                    completionHandler(false, error?.localizedDescription)
                    return
                }
                
                guard let latitude = placemark[0].location?.coordinate.latitude else {
                    print("This latitude placemark is: \(placemark)")
                    completionHandler(false, error?.localizedDescription)
                    return
                }
                
                guard let longitude = placemark[0].location?.coordinate.longitude else {
                    print("This longitude placemark is: \(placemark)")
                    completionHandler(false, error?.localizedDescription)
                    return
                }

                MyLocation.latitude = latitude
                MyLocation.longitude = longitude
                completionHandler(true, nil)
            }
        }
    }
    
    @objc func cancelButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // Display alert with error message
    private func displayAlert(errorString: String?) {
        let controller = UIAlertController()
        
        if let errorString = errorString {
            controller.message = errorString
        }
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { action in self.dismiss(animated: true, completion: nil)
        }
        controller.addAction(okAction)
        self.present(controller, animated: true, completion: nil)
    }
    
    // MARK: - Keyboard-related methods
    // Dismiss the keyboard when tapping outside the top and bottom textfields
    @objc func tap(gesture: UITapGestureRecognizer) {
        locationTextField.resignFirstResponder()
        urlTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true;
    }
    
//    func setUIEnabled(_ enabled: Bool) {
//        locationTextField.isEnabled = enabled
//        urlTextField.isEnabled = enabled
//        findLocationButton.isEnabled = enabled
//
//        if enabled {
//            findLocationButton.alpha = 1.0
//        } else {
//            findLocationButton.alpha = 0.5
//        }
//    }
    
    func animateActivityIndicator(animated: Bool) {
        if animated {
            activityIndicator.alpha = 1.0
            activityIndicator.startAnimating()
        } else {
            activityIndicator.alpha = 0.0
            activityIndicator.stopAnimating()
        }
    }
}
