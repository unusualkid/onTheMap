//
//  UdacityConvenience.swift
//  OnTheMap
//
//  Created by Kenneth Chen on 9/26/17.
//  Copyright © 2017 Cotery. All rights reserved.
//

import Foundation

// MARK: - UdacityClient (Convenient Resource Methods)

extension UdacityClient {

    func authenticateLogin(username: String, password: String, completionHandlerForLogin: @escaping (_ result: Int?, _ error: NSError?) -> Void) {
        
    }
    
    
//    func postToFavorites(_ movie: TMDBMovie, favorite: Bool, completionHandlerForFavorite: @escaping (_ result: Int?, _ error: NSError?) -> Void) {
//
//        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
//        let parameters = [TMDBClient.ParameterKeys.SessionID : TMDBClient.sharedInstance().sessionID!]
//        var mutableMethod: String = Methods.AccountIDFavorite
//        mutableMethod = substituteKeyInMethod(mutableMethod, key: TMDBClient.URLKeys.UserID, value: String(TMDBClient.sharedInstance().userID!))!
//        let jsonBody = "{\"\(TMDBClient.JSONBodyKeys.MediaType)\": \"movie\",\"\(TMDBClient.JSONBodyKeys.MediaID)\": \"\(movie.id)\",\"\(TMDBClient.JSONBodyKeys.Favorite)\": \(favorite)}"
//
//        /* 2. Make the request */
//        let _ = taskForPOSTMethod(mutableMethod, parameters: parameters as [String:AnyObject], jsonBody: jsonBody) { (results, error) in
//
//            /* 3. Send the desired value(s) to completion handler */
//            if let error = error {
//                completionHandlerForFavorite(nil, error)
//            } else {
//                if let results = results?[TMDBClient.JSONResponseKeys.StatusCode] as? Int {
//                    completionHandlerForFavorite(results, nil)
//                } else {
//                    completionHandlerForFavorite(nil, NSError(domain: "postToFavoritesList parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse postToFavoritesList"]))
//                }
//            }
//        }
//    }
}
