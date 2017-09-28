//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Kenneth Chen on 9/26/17.
//  Copyright © 2017 Cotery. All rights reserved.
//

import Foundation

class UdacityClient: NSObject {
    
    // MARK: Properties
    
    // shared session
    var session = URLSession.shared
    
    
    // authentication state
    var accountKey: String? = nil
    var sessionID : String? = nil
    
    // MARK: Initializers
    
    override init() {
        super.init()
    }
    
    func authenticateWithViewController(username: String, password: String, completionHandlerForAuth: @escaping (_ success: Bool, _ error: String?) -> Void) -> URLSessionDataTask {

        /* 1. Set the parameters */
        // There are none...
        var parameters = [String : Any]()

        /* 2/3. Build the URL, Configure the request */
        var request = URLRequest(url: udacityURLFromParameters(parameters as [String:AnyObject]))
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: String.Encoding.utf8)

        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in

            func sendError(_ error: String) {
                print(error)
                print("URL at time of error: \(request.url)")
                completionHandlerForAuth(false, error)
            }

            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }

            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }

            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }

            /* 5/6. Parse the data and use the data (happens in completion handler) */
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range) /* subset response data! */
            
            let parsedResult: [String:AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as! [String:AnyObject]
            } catch {
                sendError("Could not parse the data as JSON: '\(data)'")
                return
            }
            
            /* GUARD: Is the "session" key in our result? */
            guard let sessionDictionary = parsedResult[UdacityClient.ResponseKeys.Session] as? [String:AnyObject] else {
                sendError("Cannot find key '\(UdacityClient.ResponseKeys.Session)' in \(parsedResult)")
                return
            }
        
            /* GUARD: Is "id" key in the sessionDictionary? */
            guard let id = sessionDictionary[UdacityClient.ResponseKeys.Id] as? String else {
                sendError("Cannot find key '\(UdacityClient.ResponseKeys.Id)' in \(sessionDictionary)")
                return
            }
            
            self.sessionID = id
            print("parsedResult: ")
            print(parsedResult)
            print("sessionID: " + self.sessionID!)
            completionHandlerForAuth(true, nil)
        }

        /* 7. Start the request */
        task.resume()

        return task
    }
    
    // create a URL from parameters
    func udacityURLFromParameters(_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = UdacityClient.Constants.ApiScheme
        components.host = UdacityClient.Constants.ApiHost
        components.path = UdacityClient.Constants.ApiPath + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        print(components.url!)
        return components.url!
    }
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
}
