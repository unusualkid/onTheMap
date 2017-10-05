//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Kenneth Chen on 9/16/17.
//  Copyright © 2017 Cotery. All rights reserved.
//

import Foundation

class ParseClient : NSObject {
    
    // shared session
    var session = URLSession.shared
    
    // MARK: Initializers
    
    override init() {
        super.init()
    }
    
    func getStudentLocations(completionHandlerForGetStudentLocations: @escaping (_ result: [StudentLocation]?, _ error: String?) -> Void) -> URLSessionDataTask {
        /* 1. Set the parameters */
        // There are none...
        var parameters = ["limit" : 10]
        
        /* 2/3. Build the URL, Configure the request */
        var url = parseURLFromParameters(parameters as [String:AnyObject])
        var method = "getStudentLocations"
        var request = createRequest(httpMethod: ParseClient.HTTPMethods.Get, url: url)
        
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            func sendError(_ error: String) {
                print(error)
                print("URL at time of error: \(request.url)")
                completionHandlerForGetStudentLocations(nil, error)
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
            let parsedResult: [String:AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
            } catch {
                sendError("Could not parse the data as JSON: '\(data)'")
                return
            }
            
            print(parsedResult)
            
            /* GUARD: Is the "result" key in our result? */
            guard let results = parsedResult[ParseClient.ResponseKeys.Results] as? [[String:AnyObject]] else {
                sendError("Cannot find key '\(ParseClient.ResponseKeys.Results)' in \(parsedResult)")
                return
            }
            
            let studentLocations = ParseClient.studentLocationsFromResults(results)
            
            for studentLocation in studentLocations {
                print(studentLocation)
            }
            
            completionHandlerForGetStudentLocations(studentLocations, nil)
        }
        task.resume()
        
        return task
    }
    
    func postStudentLocation(completionHandlerForPostStudentLocations: @escaping (_ success: Bool, _ error: String?) -> Void) -> URLSessionDataTask {
        /* 1. Set the parameters */
        // There are none...
        var parameters = [String : Any]()
        
        /* 2/3. Build the URL, Configure the request */
        var url = parseURLFromParameters(parameters as [String:AnyObject])
        var method = "postStudentLocations"
        var request = createRequest(httpMethod: ParseClient.HTTPMethods.Post, url: url)
        
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            func sendError(_ error: String) {
                print(error)
                print("URL at time of error: \(request.url)")
                completionHandlerForPostStudentLocations(false, error)
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
            let parsedResult: [String:AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
            } catch {
                sendError("Could not parse the data as JSON: '\(data)'")
                return
            }
            
            print(parsedResult)
            
            completionHandlerForPostStudentLocations(true, nil)
        }
        task.resume()
        
        return task
    }
    
    
    // load JSON data returned from Parse API into the local dictionary of student locations
    static func studentLocationsFromResults(_ results: [[String:AnyObject]]) -> [StudentLocation] {
        var studentLocations = [StudentLocation]()
        
        // iterate through array of dictionaries, each Movie is a dictionary
        for result in results {
            studentLocations.append(StudentLocation(dictionary: result))
        }
        return studentLocations
    }
    
    // create request from a URL
    func createRequest(httpMethod: String, url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.addValue(ParseClient.Constants.ApplicationId, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(ParseClient.Constants.ApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        if (httpMethod == ParseClient.HTTPMethods.Post || httpMethod == ParseClient.HTTPMethods.Put) {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Mountain View, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.386052, \"longitude\": -122.083851}".data(using: String.Encoding.utf8)
        }
        return request
    }
    
    // create a URL from parameters
    func parseURLFromParameters(_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL {
        var components = URLComponents()
        components.scheme = ParseClient.Constants.ApiScheme
        components.host = ParseClient.Constants.ApiHost
        components.path = ParseClient.Constants.ApiPath
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        print(components.url!)
        return components.url!
    }
    
    // MARK: Shared Instance
    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }
}
