//
//  PostingConfirmViewController.swift
//  OnTheMap
//
//  Created by Kenneth Chen on 10/3/17.
//  Copyright © 2017 Cotery. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class PostingConfirmViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // The lat and long are used to create a CLLocationCoordinates2D instance.
        let coordinate = CLLocationCoordinate2D(latitude: MyLocation.latitude, longitude: MyLocation.longitude)
        
        // Here we create the annotation and set its coordiate, title, and subtitle properties
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
//        mapView.centerCoordinate = coordinate
        let region = MKCoordinateRegionMakeWithDistance(coordinate, 20000, 20000)
        mapView.setRegion(region, animated: true)
        
        annotation.title = "\(MyLocation.firstName) \(MyLocation.lastName)"
        annotation.subtitle = MyLocation.mediaUrl
        
        self.mapView.addAnnotation(annotation)
    }
    
    @IBAction func finishButtonPressed(_ sender: Any) {
        if MyLocation.createdAt != "" {
            ParseClient.sharedInstance.putStudentLocation { (success, error) in
                performUIUpdatesOnMain {
                    if success {
                        self.navigationController?.popToRootViewController(animated: true)
                    } else {
                        self.displayAlert(errorString: error)
                    }
                }
            }
        } else {
            ParseClient.sharedInstance.postStudentLocation { (success, error) in
                performUIUpdatesOnMain {
                    if success {
                        self.navigationController?.popToRootViewController(animated: true)
                    } else {
                        self.displayAlert(errorString: error)
                    }
                }
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
}

extension PostingConfirmViewController: MKMapViewDelegate {
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
}
