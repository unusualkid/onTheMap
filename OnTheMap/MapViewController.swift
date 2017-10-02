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
    
    @IBOutlet weak var mapView: MKMapView!
    
    // The "locations" array is an array of dictionary objects that are similar to the JSON
    // data that you can download from parse.
    var locations = [StudentLocation]()
    
    // We will create an MKPointAnnotation for each dictionary in "locations". The
    // point annotations will be stored in this array, and then provided to the map view.
    var annotations = [MKPointAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create and set the logout button
        parent!.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .reply, target: self, action: #selector(logout))
        
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refresh))
        let addPinButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPin))
        parent!.navigationItem.rightBarButtonItems = [addPinButton, refreshButton]
        
        ParseClient.sharedInstance().getStudentLocations() { (studentLocations, error) in
            if let studentLocations = studentLocations {
                self.locations = studentLocations
                
                // The "locations" array is loaded with the sample data below. We are using the dictionaries
                // to create map annotations. This would be more stylish if the dictionaries were being
                // used to create custom structs. Perhaps StudentLocation structs.
                
                for location in self.locations {
                    
                    // Notice that the float values are being used to create CLLocationDegree values.
                    // This is a version of the Double type.
                    let lat = CLLocationDegrees(location.latitude! as Float)
                    let long = CLLocationDegrees(location.longitude! as Float)
                    
                    // The lat and long are used to create a CLLocationCoordinates2D instance.
                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    
                    let first = location.firstName
                    let last = location.lastName
                    let mediaURL = location.mediaURL
                    
                    // Here we create the annotation and set its coordiate, title, and subtitle properties
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = "\(first) \(last)"
                    annotation.subtitle = mediaURL
                    
                    // Finally we place the annotation in an array of annotations.
                    self.annotations.append(annotation)
                }
                // When the array is complete, we add the annotations to the map.
                self.mapView.addAnnotations(self.annotations)
            } else {
                print(error)
            }
        }
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

