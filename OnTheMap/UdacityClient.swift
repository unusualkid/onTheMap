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
        var request = URLRequest(url: udacityURLFromParameters(parameters as [String:AnyObject], method: "session"))
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
                print("Cannot find key '\(UdacityClient.ResponseKeys.Session)' in \(parsedResult)")
                sendError("Invalid credentials")
                return
            }
            
            /* GUARD: Is "id" key in the sessionDictionary? */
            guard let id = sessionDictionary[UdacityClient.ResponseKeys.Id] as? String else {
                sendError("Cannot find key '\(UdacityClient.ResponseKeys.Id)' in \(sessionDictionary)")
                return
            }
            
            /* GUARD: Is the "account" key in our result? */
            guard let accountDictionary = parsedResult[UdacityClient.ResponseKeys.Account] as? [String:AnyObject] else {
                sendError("Cannot find key '\(UdacityClient.ResponseKeys.Account)' in \(parsedResult)")
                return
            }
            
            /* GUARD: Is "key" key in the accountDictionary? */
            guard let accountKey = accountDictionary[UdacityClient.ResponseKeys.Key] as? String else {
                sendError("Cannot find key '\(UdacityClient.ResponseKeys.Key)' in \(accountDictionary)")
                return
            }
            
            self.sessionID = id
            self.accountKey = accountKey
            MyLocation.uniqueKey = accountKey
            print("parsedResult: ")
            print(parsedResult)
            print("sessionID: " + self.sessionID!)
            print("accountKey: " + self.accountKey!)
            completionHandlerForAuth(true, nil)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    func getUserData(completionHandlerForGetUserData: @escaping (_ result: [String:AnyObject]?, _ error: String?) -> Void) -> URLSessionDataTask {
        /* 1. Set the parameters */
        // There are none...
        var parameters = [String : Any]()
        
        /* 2/3. Build the URL, Configure the request */
        var request = URLRequest(url: udacityURLFromParameters(parameters as [String:AnyObject], method: "user"))
        
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            func sendError(_ error: String) {
                print(error)
                print("URL at time of error: \(request.url)")
                completionHandlerForGetUserData(nil, error)
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
            
            /* GUARD: Is the "user" key in our result? */
            guard let userDictionary = parsedResult[UdacityClient.ResponseKeys.User] as? [String:AnyObject] else {
                sendError("Cannot find key '\(UdacityClient.ResponseKeys.User)' in \(parsedResult)")
                return
            }
            
            /* GUARD: Is "last_name" key in the userDictionary? */
            guard let lastName = userDictionary[UdacityClient.ResponseKeys.lastName] as? String else {
                sendError("Cannot find key '\(UdacityClient.ResponseKeys.lastName)' in \(userDictionary)")
                return
            }
            
            /* GUARD: Is "first_name" key in the userDictionary? */
            guard let firstName = userDictionary[UdacityClient.ResponseKeys.firstName] as? String else {
                sendError("Cannot find key '\(UdacityClient.ResponseKeys.firstName)' in \(userDictionary)")
                return
            }
            MyLocation.firstName = firstName
            MyLocation.lastName = lastName
            completionHandlerForGetUserData(parsedResult, nil)
        }
        task.resume()
        
        return task
    }
    
    
    func logoutWithViewController(completionHandlerForLogout: @escaping (_ success: Bool, _ error: String?) -> Void) -> URLSessionDataTask {
        
        /* 1. Set the parameters */
        // There are none...
        var parameters = [String : Any]()
        
        /* 2/3. Build the URL, Configure the request */
        var request = URLRequest(url: udacityURLFromParameters(parameters as [String:AnyObject], method: "session"))
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                print("URL at time of error: \(request.url)")
                completionHandlerForLogout(false, error)
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
            
            self.sessionID = ""
            completionHandlerForLogout(true, nil)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    // create a URL from parameters
    func udacityURLFromParameters(_ parameters: [String:AnyObject], withPathExtension: String? = nil, method: String) -> URL {
        var components = URLComponents()
        components.scheme = UdacityClient.Constants.ApiScheme
        components.host = UdacityClient.Constants.ApiHost
        components.path = method == "session" ? UdacityClient.Constants.ApiPath + UdacityClient.Constants.SessionPath : UdacityClient.Constants.ApiPath + UdacityClient.Constants.UserPath + "/" + self.accountKey!
        components.path += (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
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
