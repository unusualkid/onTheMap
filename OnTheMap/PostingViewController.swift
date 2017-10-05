//
//  PostingViewController.swift
//  OnTheMap
//
//  Created by Kenneth Chen on 9/29/17.
//  Copyright © 2017 Cotery. All rights reserved.
//

import UIKit

class PostingViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.alpha = 0.0
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
            activityIndicator.alpha = 1.0
            activityIndicator.startAnimating()
            let controller = storyboard!.instantiateViewController(withIdentifier: "PostingConfirmViewController") as! PostingConfirmViewController
            if let location = locationTextField.text {
                controller.locationName = location
            }
            if let url = urlTextField.text {
                controller.url = url
            }
            navigationController!.pushViewController(controller, animated: true)
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
}
