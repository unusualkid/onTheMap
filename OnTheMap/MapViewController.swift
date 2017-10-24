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
    
    // We will create an MKPointAnnotation for each dictionary in "locations". The
    // point annotations will be stored in this array, and then provided to the map view.
    var annotations = [MKPointAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create and set the logout button
        parent?.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "LOGOUT", style: .plain, target: self, action: #selector(logout))
        
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshButtonPressed))
        let addPinButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPinButtonPressed))
        parent?.navigationItem.rightBarButtonItems = [addPinButton, refreshButton]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mapView.removeAnnotations(annotations)
        StudentLocation.locations = []
        annotations = []
        self.getStudentLocations()
    }
    
    @objc func logout() {
        UdacityClient.sharedInstance().logoutWithViewController() { (success, error) in
            performUIUpdatesOnMain {
                if success {
                    self.dismiss(animated: true, completion: nil)
                }
                else {
                    self.displayAlert(errorString: error)
                }
            }
        }
    }
    
    @objc func refreshButtonPressed() {
        print("MapViewController - refreshButtonPressed()")
        print("MyLocation.firstName: " + MyLocation.firstName)
        print("MyLocation.lastName: " + MyLocation.lastName)
        print("MyLocation.MyLocation.mapString: " + MyLocation.mapString)
        print("MyLocation.mediaUrl: " + MyLocation.mediaUrl)
        print("MyLocation.latitude: " + String(MyLocation.latitude))
        print("MyLocation.longitude: " + String(MyLocation.longitude))
        print("MyLocation.objectId: " + MyLocation.objectId)
        print("MyLocation.uniqueKey: " + MyLocation.uniqueKey)
        print("MyLocation.createdAt: " + MyLocation.createdAt)
        print("MyLocation.updatedAt: " + MyLocation.updatedAt)
        mapView.removeAnnotations(annotations)
        StudentLocation.locations = []
        annotations = []
        self.getStudentLocations()
    }
    
    @objc func addPinButtonPressed() {
        ParseClient.sharedInstance().getOneStudentLocation { (success, error) in
            performUIUpdatesOnMain {
                if success {
                    self.displayAlertForOverwrite(errorString: "User \(MyLocation.firstName) \(MyLocation.lastName) has already posted a Student Location. Would you like to overwrite their location?")
                } else {
                    print("new user")
                    let controller = self.storyboard!.instantiateViewController(withIdentifier: "PostingViewController") as! PostingViewController
                    self.navigationController!.pushViewController(controller, animated: true)
                }
            }
        }
    }
    
    private func getStudentLocations() {
        ParseClient.sharedInstance().getStudentLocations() { (studentLocations, error) in
            performUIUpdatesOnMain {
                if let studentLocations = studentLocations {
                    StudentLocation.locations = studentLocations
                    for location in StudentLocation.locations {
                        
                        // Notice that the float values are being used to create CLLocationDegree values.
                        // This is a version of the Double type.
                        let lat = CLLocationDegrees(location.latitude as Float)
                        let long = CLLocationDegrees(location.longitude as Float)
                        
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
                    self.displayAlert(errorString: error)
                    print(error)
                }
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
        present(controller, animated: true, completion: nil)
    }
    
    private func displayAlertForOverwrite(errorString: String?) {
        let controller = UIAlertController()
        
        if let errorString = errorString {
            controller.message = errorString
        }
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { action in
            controller.dismiss(animated: true, completion: nil)
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: "PostingViewController") as! PostingViewController
            self.navigationController!.pushViewController(viewController, animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default) { action in
            controller.dismiss(animated: true, completion: nil)
        }
        
        controller.addAction(okAction)
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)
    }
}

extension MapViewController: MKMapViewDelegate {
    
    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
            }
        }
    }
}
