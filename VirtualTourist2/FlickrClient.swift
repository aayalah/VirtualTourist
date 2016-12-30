//
//  FlickrClient.swift
//  VirtualTourist
//
//  Created by Alejandro Ayala-Hurtado on 12/27/16.
//  Copyright © 2016 MobileApps. All rights reserved.
//

import Foundation

class FlickrClient {
    
    private let session = URLSession.shared
    
    static let instance = FlickrClient()
    
    class func sharedInstance() -> FlickrClient {
        return instance
    }
    
    
    func taskForGetMethod(_ method: String, parameters: [String:AnyObject], jsonBody: String, completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        let request = NSMutableURLRequest(url: formURLWithParams(parameters: parameters, method: method)!)
        request.httpMethod = Constants.GET
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            func sendError(_ error: String, code: Int) {
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: code, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)", code: 1)
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!", code: 2)
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!", code: 1)
                return
            }
            
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
            
        }
        
        task.resume()
        return task
        
        
    }
    
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    
    private func formURLWithParams(parameters: [String:AnyObject], method: String? = nil) -> URL? {
        
        var url = URLComponents(string: method!)
        url?.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            
            url?.queryItems!.append(URLQueryItem(name: key, value: "\(value)"))
            
        }
        
        return url?.url
    }
}
