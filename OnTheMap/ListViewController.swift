//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Kenneth Chen on 9/28/17.
//  Copyright © 2017 Cotery. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        StudentLocation.locations = []
        self.getStudentLocations()
    }
    
    private func getStudentLocations() {
        ParseClient.sharedInstance().getStudentLocations { (locations, error) in
            if let locations = locations {
                StudentLocation.locations = locations
                performUIUpdatesOnMain {
                    self.tableView.reloadData()
                }
            } else {
                print(error ?? "empty error")
            }
        }
    }
    
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
}

extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentLocation.locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let location = StudentLocation.locations[(indexPath as NSIndexPath).row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell")!
        cell.imageView?.image = UIImage(named: "icon_pin")
        cell.imageView?.contentMode = .scaleAspectFit
        cell.textLabel?.text = location.firstName + " " + location.lastName
        if let detailTextLabel = cell.detailTextLabel {
            detailTextLabel.text = location.mediaURL
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = StudentLocation.locations[(indexPath as NSIndexPath).row]
        if location.mediaURL.prefix(8) == "https://" {
            UIApplication.shared.open(URL(string: location.mediaURL)!, options: [:], completionHandler: nil)
        } else {
            displayAlert(errorString: "Cannot launch URLs that don't start with 'https://'1.")
        }
    }
}


