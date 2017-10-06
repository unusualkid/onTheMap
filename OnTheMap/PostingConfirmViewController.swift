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
    
    //    var locationName = ""
    //    var url = ""
    //    var location = CLLocation(latitude: 0, longitude: 0)
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(MyLocation.address)
        print(MyLocation.url)
        print(MyLocation.latitude)
        print(MyLocation.longitude)
        
        // The lat and long are used to create a CLLocationCoordinates2D instance.
        let coordinate = CLLocationCoordinate2D(latitude: MyLocation.latitude, longitude: MyLocation.longitude)
        
        let first = "Kenneth"
        let last = "Chen"
        
        // Here we create the annotation and set its coordiate, title, and subtitle properties
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.centerCoordinate = coordinate
        
        annotation.title = "\(first) \(last)"
        annotation.subtitle = MyLocation.url
        
        // When the array is complete, we add the annotations to the map.
        self.mapView.addAnnotation(annotation)
    }
    
    @IBAction func finishButtonPressed(_ sender: Any) {
        // Call postStudentLocation
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
