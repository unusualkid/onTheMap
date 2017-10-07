//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Kenneth Chen on 9/20/17.
//  Copyright © 2017 Cotery. All rights reserved.
//

import Foundation

struct StudentLocation {
    
    // MARK: Properties
    
    var objectId: String
    var uniqueKey: String?
    var firstName: String
    var lastName: String
    var mapString: String?
    var mediaURL: String?
    var latitude: Float?
    var longitude: Float?
    var createdAt: String?
    var updatedAt: String?
    //    var ACL: String
    
    // construct a StudentLocation from a dictionary
    init(dictionary: [String:AnyObject]) {
        objectId = dictionary[ParseClient.ResponseKeys.ObjectId] as! String
        if let uniqueKey = dictionary[ParseClient.ResponseKeys.UniqueKey] as? String {
            self.uniqueKey = uniqueKey
        } else {
            self.uniqueKey = ""
        }
        firstName = dictionary[ParseClient.ResponseKeys.FirstName] as! String
        lastName = dictionary[ParseClient.ResponseKeys.LastName] as! String
        if let longitude = dictionary[ParseClient.ResponseKeys.Longitude] as? Float {
            self.longitude = longitude
        } else {
            self.longitude = 91
        }
        if let latitude = dictionary[ParseClient.ResponseKeys.Latitude] as? Float {
            self.latitude = latitude
        } else {
            self.latitude = 181
        }
        if let createdAtString = dictionary[ParseClient.ResponseKeys.CreatedAt] as? String, createdAtString.isEmpty == false {
            createdAt = createdAtString.substring(to: createdAtString.characters.index(createdAtString.startIndex, offsetBy: 10))
        }
        if let updatedAtString = dictionary[ParseClient.ResponseKeys.CreatedAt] as? String, updatedAtString.isEmpty == false {
            updatedAt = updatedAtString.substring(to: updatedAtString.characters.index(updatedAtString.startIndex, offsetBy: 10))
        }
        if let mapString = dictionary[ParseClient.ResponseKeys.MapString] as? String, mapString.isEmpty == false {
            self.mapString = mapString
        } else {
            self.mapString = ""
        }
        if let mediaUrl = dictionary[ParseClient.ResponseKeys.MediaUrl] as? String, mediaUrl.isEmpty == false {
            self.mediaURL = mediaUrl
        } else {
            self.mediaURL = ""
        }
    }
}
