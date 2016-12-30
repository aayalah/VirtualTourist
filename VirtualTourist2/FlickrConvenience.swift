//
//  FlickrConvenience.swift
//  VirtualTourist
//
//  Created by Alejandro Ayala-Hurtado on 12/27/16.
//  Copyright © 2016 MobileApps. All rights reserved.
//


import Foundation


extension FlickrClient {
    
    
    
    func getPhotosFromLocation(latitude: Double, longitude: Double, storeResult: @escaping (_ longitude: Double, _ latitude: Doublea, _ result: AnyObject?) -> Bool, completionHandler: @escaping (Bool, NSError?) -> Void) {
        
        var parameters = [PhotosGetParameters.method : "\(PhotosMethods.photosForLocation)"]
        parameters[PhotosGetParameters.api_key] = "\(Constants.API_KEY)"
        parameters[PhotosGetParameters.lat] = "\(latitude)"
        parameters[PhotosGetParameters.lon] = "\(longitude)"
        parameters[PhotosGetParameters.per_page] = "\(Constants.PhotosConstants.PER_PAGE)"
        parameters[PhotosGetParameters.format] = "\(Constants.PhotosConstants.FORMAT)"
        parameters[PhotosGetParameters.noJSONCallback] = "\(Constants.PhotosConstants.JSON_CALLBACK)"
        parameters[PhotosGetParameters.bbox] = "\(longitude-1),\(latitude-1),\(longitude+1),\(latitude+1)"
        _ = taskForGetMethod(Constants.Api_Url, parameters: parameters as [String : AnyObject], jsonBody: "") { result, error in
            if error == nil {
                
                completionHandler(storeResult(longitude, latitude, result), nil)
                
                
            } else {
                completionHandler(false, error!)
            }
            
        }
        
    }
    
    
}
