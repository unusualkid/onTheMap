//
//  UdacityConstants.swift
//  OnTheMap
//
//  Created by Kenneth Chen on 9/26/17.
//  Copyright © 2017 Cotery. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    // MARK: Constants
    struct Constants {
        // MARK: URLs
        static let ApiScheme = "https"
        static let ApiHost = "www.udacity.com"
        static let ApiPath = "/api"
        static let SessionPath = "/session"
        static let UserPath = "/users"
    }
    
    // MARK: Udacity Parameter Keys
    struct ParameterKeys {
        static let Udacity = "udacity"
        static let Username = "username"
        static let Password = "password"
    }
    
    struct ResponseKeys {
        static let Account = "account"
        static let Registered = "registered"
        static let Key = "key"
        static let Session = "session"
        static let Id = "id"
        static let Expiration = "expiration"
    }
}
