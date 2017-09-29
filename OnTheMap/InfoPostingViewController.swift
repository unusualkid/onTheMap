//
//  InfoPostingViewController.swift
//  OnTheMap
//
//  Created by Kenneth Chen on 9/29/17.
//  Copyright © 2017 Cotery. All rights reserved.
//

import UIKit

class InfoPostingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Add Location"
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel))
    }
    
//    @objc func cancel() {
//        dismiss
//    }
}
