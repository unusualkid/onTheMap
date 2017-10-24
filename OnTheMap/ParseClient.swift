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
    
    // MARK: Shared Instance
    static let sharedInstance = ParseClient()
    
    override init() {
        super.init()
    }
    
    func getStudentLocations(completionHandlerForGetStudentLocations: @escaping (_ result: [StudentLocation]?, _ error: String?) -> Void) -> URLSessionDataTask {
        /* 1. Set the parameters */
        // There are none...
        var parameters = ["limit" : 100,
                          "order": "-updatedAt"] as [String : Any]
        
        /* 2/3. Build the URL, Configure the request */
        var url = parseURLFromParameters(parameters as [String:AnyObject])
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
                sendError("There was an error with your request: \(error!.localizedDescription)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                if let httpResponse = response as? HTTPURLResponse {
                    sendError("Your request returned a status code other than 2xx! Status code:  \(httpResponse.statusCode)")
                }
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
            
            /* GUARD: Is the "result" key in our result? */
            guard let results = parsedResult[ParseClient.ResponseKeys.Results] as? [[String:AnyObject]] else {
                sendError("Cannot find key '\(ParseClient.ResponseKeys.Results)' in \(parsedResult)")
                return
            }
            
//            self.studentLocations = ParseClient.studentLocationsFromResults(results)
            StudentLocation.locations = ParseClient.studentLocationsFromResults(results)
            completionHandlerForGetStudentLocations(StudentLocation.locations, nil)
        }
        task.resume()
        
        return task
    }
    
    func getOneStudentLocation(completionHandlerForGetOneStudentLocation: @escaping (_ success: Bool, _ error: String?) -> Void) -> URLSessionDataTask {
        /* 1. Set the parameters */
        var parameters = [ParseClient.Constants.Where: MyLocation.uniqueKey]
        
        /* 2/3. Build the URL, Configure the request */
        var url = parseURLFromParametersForGetOneLocation(parameters as [String:AnyObject])
        var request = createRequest(httpMethod: ParseClient.HTTPMethods.Get, url: url)
        
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            func sendError(_ error: String) {
                print(error)
                print("URL at time of error: \(request.url)")
                completionHandlerForGetOneStudentLocation(false, error)
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!.localizedDescription)")
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
            
            /* GUARD: Is the "result" key in our result? */
            guard let results = parsedResult[ParseClient.ResponseKeys.Results] as? [[String:AnyObject]] else {
                sendError("Cannot find key '\(ParseClient.ResponseKeys.Results)' in \(parsedResult)")
                return
            }
            
            print("results.count: " + String(results.count))
            
            if results.count == 0 {
                completionHandlerForGetOneStudentLocation(false, nil)
            } else {
                let studentLocation = StudentLocation(dictionary: results.last!)
                MyLocation.mapString = studentLocation.mapString
                MyLocation.mediaUrl = studentLocation.mediaURL
                MyLocation.latitude = Double(studentLocation.latitude)
                MyLocation.longitude = Double(studentLocation.longitude)
                MyLocation.createdAt = studentLocation.createdAt
                MyLocation.updatedAt = studentLocation.updatedAt
                MyLocation.objectId = studentLocation.objectId
                
                completionHandlerForGetOneStudentLocation(true, nil)
            }
        }
        task.resume()
        
        return task
    }
    
    func postStudentLocation(completionHandlerForPostStudentLocation: @escaping (_ success: Bool, _ error: String?) -> Void) -> URLSessionDataTask {
        /* 1. Set the parameters */
        // There are none...
        var parameters = [String : Any]()
        
        /* 2/3. Build the URL, Configure the request */
        var url = parseURLFromParameters(parameters as [String:AnyObject])
        var request = createRequest(httpMethod: ParseClient.HTTPMethods.Post, url: url)
        
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            func sendError(_ error: String) {
                print(error)
                print("URL at time of error: \(request.url)")
                completionHandlerForPostStudentLocation(false, error)
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!.localizedDescription)")
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
            
            /* GUARD: Is the "createdAt" key in our result? */
            guard let createdAt = parsedResult[ParseClient.ResponseKeys.CreatedAt] as? String else {
                sendError("Cannot find key '\(ParseClient.ResponseKeys.CreatedAt)' in \(parsedResult)")
                return
            }
            /* GUARD: Is the "objectId" key in our result? */
            guard let objectId = parsedResult[ParseClient.ResponseKeys.ObjectId] as? String else {
                sendError("Cannot find key '\(ParseClient.ResponseKeys.ObjectId)' in \(parsedResult)")
                return
            }
            
            MyLocation.createdAt = createdAt
            MyLocation.updatedAt = createdAt
            MyLocation.objectId = objectId
            completionHandlerForPostStudentLocation(true, nil)
        }
        task.resume()
        
        return task
    }
    
    func putStudentLocation(completionHandlerForPutStudentLocation: @escaping (_ success: Bool, _ error: String?) -> Void) -> URLSessionDataTask {
        /* 1. Set the parameters */
        // There are none...
        var parameters = [String : Any]()
        
        /* 2/3. Build the URL, Configure the request */
        var url = parseURLFromParameters(parameters as [String:AnyObject])
        url.appendPathComponent(MyLocation.objectId)
        var method = "putStudentLocation"
        var request = createRequest(httpMethod: ParseClient.HTTPMethods.Put, url: url)
        
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            func sendError(_ error: String) {
                print(error)
                print("URL at time of error: \(request.url)")
                completionHandlerForPutStudentLocation(false, error)
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!.localizedDescription)")
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
            
            /* GUARD: Is the "updatedAt" key in our result? */
            guard let updatedAt = parsedResult[ParseClient.ResponseKeys.UpdatedAt] as? String else {
                sendError("Cannot find key '\(ParseClient.ResponseKeys.UpdatedAt)' in \(parsedResult)")
                return
            }
            let index = updatedAt.characters.index(updatedAt.startIndex, offsetBy: 10)
            MyLocation.updatedAt = String(updatedAt[..<index])

            completionHandlerForPutStudentLocation(true, nil)
        }
        task.resume()
        
        return task
    }
    
    // load JSON data returned from Parse API into the local array of student location dictionaries
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
            request.httpBody = "{\"uniqueKey\": \"\(MyLocation.uniqueKey)\", \"firstName\": \"\(MyLocation.firstName)\", \"lastName\": \"\(MyLocation.lastName)\",\"mapString\": \"\(MyLocation.mapString)\", \"mediaURL\": \"\(MyLocation.mediaUrl)\",\"latitude\": \(MyLocation.latitude), \"longitude\": \(MyLocation.longitude)}".data(using: String.Encoding.utf8)
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
    
    // Parse method for getStudentLocationFromParse()
    private func parseURLFromParametersForGetOneLocation(_ parameters: [String: AnyObject], withPathExtension: String? = nil) -> URL {
        var components = URLComponents()
        components.scheme = ParseClient.Constants.ApiScheme
        components.host = ParseClient.Constants.ApiHost
        components.path = ParseClient.Constants.ApiPath
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "{\"uniqueKey\":\"\(value)\"}")
            components.queryItems!.append(queryItem)
        }
        print(components.url!)
        return components.url!
    }
}
