//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Kenneth Chen on 9/28/17.
//  Copyright © 2017 Cotery. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create and set the logout button
        parent!.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .reply, target: self, action: #selector(logout))
        
        var refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refresh))
        var addPinButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPin))
        parent!.navigationItem.rightBarButtonItems = [addPinButton, refreshButton]
        
    }
    
    @IBAction func getUserData(_ sender: Any) {
        UdacityClient.sharedInstance().getUserData() {(data, error) in
            print("finished")
        }
    }
    
    @objc func logout() {
        UdacityClient.sharedInstance().logoutWithViewController() { (success, error) in
            performUIUpdatesOnMain {
                print("success: " + String(success))
                if success {
                    self.dismiss(animated: true, completion: nil)
                }
                else {
                    self.displayAlert(errorString: error)
                }
            }
        }
    }
    
    @objc func refresh() {
        
    }
    
    @objc func addPin() {
        let controller = storyboard!.instantiateViewController(withIdentifier: "InfoPostingViewController") as! UIViewController
        navigationController!.pushViewController(controller, animated: true)
//        present(controller, animated: true, completion: nil)
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

