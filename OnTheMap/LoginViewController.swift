//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Kenneth Chen on 9/16/17.
//  Copyright © 2017 Cotery. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animateActivityIndicator(animated: false)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tap(gesture:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        if usernameTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            displayAlert(errorString: "Username or password empty.")
        } else {
            animateActivityIndicator(animated: true)
            UdacityClient.sharedInstance().authenticateWithViewController(username: usernameTextField.text!, password: passwordTextField.text!) { (success, error) in
                performUIUpdatesOnMain {
                    if success {
                        self.animateActivityIndicator(animated: false)
                        self.completeLogin()
                        self.usernameTextField.text = ""
                        self.passwordTextField.text = ""
                    } else {
                        self.animateActivityIndicator(animated: false)
                        self.displayAlert(errorString: error)
                    }
                }
            }
        }
    }
    
    @IBAction func signupButtonPressed(_ sender: Any) {
        let app = UIApplication.shared
        app.open(URL(string: "https://in.udacity.com/auth/")!, options: [:], completionHandler: nil)
    }
    
    
    private func completeLogin() {
        let controller = storyboard!.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
        present(controller, animated: true, completion: nil)
        UdacityClient.sharedInstance().getUserData() {(result, error) in
            if let error = error {
                print("Could not get user data: \(error)")
            } else if let result = result {
                print("My Udacity user info is successfully loaded into MyLocation.")
            }
        }
    }
    
    // Display alert with error message
    private func displayAlert(errorString: String?) {
        let controller = UIAlertController()
        
        if let errorString = errorString {
            controller.message = errorString
        }
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { action in controller.dismiss(animated: true, completion: nil)
        }
        controller.addAction(okAction)
        self.present(controller, animated: true, completion: nil)
    }
    
    // MARK: - Keyboard-related methods
    // Dismiss the keyboard when tapping outside the top and bottom textfields
    @objc func tap(gesture: UITapGestureRecognizer) {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true;
    }
    
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

