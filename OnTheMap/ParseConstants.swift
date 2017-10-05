//
//  ParseConstants.swift
//  OnTheMap
//
//  Created by Kenneth Chen on 9/16/17.
//  Copyright © 2017 Cotery. All rights reserved.
//

import Foundation

extension ParseClient {
    
    // MARK: Constants
    struct Constants {
        
        // MARK: ApplicationId
        static let ApplicationId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let ApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        
        // MARK: URLs
        static let ApiScheme = "https"
        static let ApiHost = "parse.udacity.com"
        static let ApiPath = "/parse/classes/StudentLocation"
    }
    
    struct ResponseKeys {
        static let Results = "results"
    }
    
    // MARK: Methods
    struct HTTPMethods {
        static let Get = "GET"
        static let Post = "POST"
        static let Put = "PUT"
    }

    // MARK: URL Keys
    struct URLKeys {
        
    }
    
    // MARK: Parameter Keys
    struct ParameterKeys {
        
    }
    
    // MARK: JSON Keys
    struct JSONResponseKeys {
        static let ObjectId = "objectId"
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MapString = "mapString"
        static let MediaUrl = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let CreatedAt = "createdAt"
        static let UpdatedAt = "updatedAt"
//        static let ACL: String
    }

}
