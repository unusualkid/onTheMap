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
    var uniqueKey: String
    var firstName: String
    var lastName: String
    var mapString: String
    var mediaURL: String
    var latitude: Float
    var longitude: Float
    var createdAt: String
    var updatedAt: String
    //    var ACL: String
    
    static var locations: [StudentLocation] = []
    
    // construct a StudentLocation from a dictionary
    init(dictionary: [String : AnyObject]) {
        objectId = dictionary[ParseClient.ResponseKeys.ObjectId] as! String
        if let uniqueKey = dictionary[ParseClient.ResponseKeys.UniqueKey] as? String {
            self.uniqueKey = uniqueKey
        } else {
            self.uniqueKey = ""
        }

        if let firstName = dictionary[ParseClient.ResponseKeys.FirstName] as? String {
            self.firstName = firstName
        } else {
            self.firstName = ""
        }
        
        if let lastName = dictionary[ParseClient.ResponseKeys.LastName] as? String {
            self.lastName = lastName
        } else {
            self.lastName = ""
        }
        
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
            let index = createdAtString.characters.index(createdAtString.startIndex, offsetBy: 10)
            createdAt = String(createdAtString[..<index])
        } else {
            createdAt = ""
        }
        
        if let updatedAtString = dictionary[ParseClient.ResponseKeys.UpdatedAt] as? String, updatedAtString.isEmpty == false {
            let index = updatedAtString.characters.index(updatedAtString.startIndex, offsetBy: 10)
            updatedAt = String(updatedAtString[..<index])
        } else {
            updatedAt = ""
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
