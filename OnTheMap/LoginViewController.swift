//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Kenneth Chen on 9/16/17.
//  Copyright © 2017 Cotery. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.alpha = 0.0
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        if usernameTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            displayAlert(errorString: "Username or password empty.")
        } else {
            activityIndicator.alpha = 1.0
            activityIndicator.startAnimating()
            UdacityClient.sharedInstance().authenticateWithViewController(username: usernameTextField.text!, password: passwordTextField.text!) { (success, errorString) in
                performUIUpdatesOnMain {
                    if success {
                        self.activityIndicator.isHidden = true
                        self.activityIndicator.stopAnimating()
                        self.completeLogin()
                        self.usernameTextField.text = ""
                        self.passwordTextField.text = ""
                    } else {
                        self.displayAlert(errorString: errorString)
                    }
                }
            }
        }
    }
    
    private func completeLogin() {
        let controller = storyboard!.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
        present(controller, animated: true, completion: nil)
    }
    
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
    
}

