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
    @IBOutlet weak var debugTextLabel: UILabel!
    @IBOutlet weak var signupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        // Do any additional setup after loading the view, typically from a nib.
//        
//        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
//        request.httpMethod = "POST"
//        request.addValue("application/json", forHTTPHeaderField: "Accept")
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpBody = "{\"udacity\": {\"username\": \"unusualkid@gmail.com\", \"password\": \"3OknVq9qtLo5kxZ\"}}".data(using: String.Encoding.utf8)
//        let session = URLSession.shared
//        let task = session.dataTask(with: request as URLRequest) { data, response, error in
//            if error != nil { // Handle error…
//                return
//            }
//            let range = Range(5..<data!.count)
//            let newData = data?.subdata(in: range) /* subset response data! */
//            print(NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!)
//        }
//        task.resume()
//        
        
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        if usernameTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            setUIHidden(isHidden: false, text: "Username or password empty.")
        } else {
            UdacityClient.sharedInstance().authenticateWithViewController(username: usernameTextField.text!, password: passwordTextField.text!) { (success, errorString) in
                performUIUpdatesOnMain {
                    if success {
                        self.completeLogin()
                    } else {
                        self.displayError(errorString)
                    }
                }
            }
        }
    }
    
    private func completeLogin() {
        setUIHidden(isHidden: true, text: "")
        let controller = storyboard!.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
        present(controller, animated: true, completion: nil)
    }
    
    private func displayError(_ errorString: String?) {
        if let errorString = errorString {
            setUIHidden(isHidden: false, text: errorString)
        }
    }
    
    private func setUIHidden(isHidden: Bool, text: String) {
        debugTextLabel.isHidden = isHidden
        debugTextLabel.text = text
    }
    
}

