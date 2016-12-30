//
//  Constants.swift
//  VirtualTourist
//
//  Created by Alejandro Ayala-Hurtado on 12/27/16.
//  Copyright © 2016 MobileApps. All rights reserved.
//

extension FlickrClient {
    
    
    struct Constants {
        
        static let API_KEY = "d6014d71288850eb625db15b1a5c09a4"
        static let GET = "GET"
        
        struct PhotosConstants {
            static let JSON_CALLBACK = 1
            static let FORMAT = "json"
            static let PER_PAGE = 21
        }
        
        ///URLs
        static let Api_Url = "https://api.flickr.com/services/rest/"
    }
    
    struct PhotosMethods {
        static let photosForLocation = "flickr.photos.search"
    }
    
    
    struct PhotosGetParameters {
        static let method = "method"
        static let api_key = "api_key"
        static let format = "format"
        static let lat = "lat"
        static let lon = "lon"
        static let noJSONCallback = "nojsoncallback"
        static let per_page = "per_page"
        static let bbox = "bbox"
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        
        // MARK: Photos
        static let farm = "farm"
        static let server = "server"
        static let id = "id"
        static let secret = "secret"
        static let photoBodyKey = "photos"
        static let photo = "photo"
        static let total = "total"
        
    }
    
    
    
}
