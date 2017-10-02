//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Kenneth Chen on 9/28/17.
//  Copyright © 2017 Cotery. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var locations = [StudentLocation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ParseClient.sharedInstance().getStudentLocations { (locations, error) in
            if let locations = locations {
                self.locations = locations
                performUIUpdatesOnMain {
                    self.tableView.reloadData()
                }
            } else {
                print(error ?? "empty error")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let location = locations[(indexPath as NSIndexPath).row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell")!
        cell.imageView?.image = UIImage(named: "icon_pin")
        cell.imageView?.contentMode = .scaleAspectFit
        cell.textLabel?.text = location.firstName + " " + location.lastName
        if let detailTextLabel = cell.detailTextLabel {
            if let mediaURL = location.mediaURL {
                detailTextLabel.text = mediaURL
            } else {
                detailTextLabel.text = ""
            }
        }
        return cell
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
