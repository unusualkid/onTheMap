//
//  InfoPostingViewController.swift
//  OnTheMap
//
//  Created by Kenneth Chen on 9/29/17.
//  Copyright © 2017 Cotery. All rights reserved.
//

import UIKit

class InfoPostingViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationTextField.delegate = self
        self.urlTextField.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tap(gesture:)))
        view.addGestureRecognizer(tapGesture)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Add Location"
//        self.navigationItem.backBarButtonItem?.title = "Cancel"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel))
    }
    
    @objc func cancel() {
        self.navigationController?.popViewController(animated: true)
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
