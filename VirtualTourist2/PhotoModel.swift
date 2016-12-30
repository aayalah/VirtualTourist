//
//  PhotoModel.swift
//  VirtualTourist
//
//  Created by Alejandro Ayala-Hurtado on 12/27/16.
//  Copyright © 2016 MobileApps. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class PhotoModel {
    
    static let instance = PhotoModel()
    
    class func sharedInstance()-> PhotoModel {
        return instance
    }
    
    func getPhotos(latitude: Double, longitude: Double) {
        
        
        
        FlickrClient.sharedInstance().getPhotosFromLocation(latitude: latitude, longitude: longitude, storeResult: storePhotos) { success, error in
            
            
        }
        
    }
    
    private func storePhotos(longitude:Double, latitude: Double, result: AnyObject?) -> Bool {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        let entity =  NSEntityDescription.entity(forEntityName: "Pin",
                                                 in:context)
        
        let pin = NSManagedObject(entity: entity!,
                                  insertInto: context) as! Pin
        
        pin.latitude = latitude
        pin.longitude = longitude
        
        if let photoResults = parsePhotoResults(result: result) {
            return addPhotosToContext(longitude: longitude, latitude: latitude, result: photoResults, pin: pin)
        }
        return false
        
    }
    
    private func addPhotosToContext(longitude:Double, latitude:Double, result: [String:AnyObject], pin: Pin) -> Bool {
        let arr =  result[FlickrClient.JSONResponseKeys.photo] as! [AnyObject]
        
        
        for item in arr {
            let item = item as! [String:AnyObject]
            
            let entity = NSEntityDescription.entity(forEntityName: "Photo", in: pin.managedObjectContext!)
            let photo = NSManagedObject(entity: entity!, insertInto: pin.managedObjectContext) as! Photo
            
            let farm = item[FlickrClient.JSONResponseKeys.farm] as! Int
            let server = item[FlickrClient.JSONResponseKeys.server] as! String
            let secret = item[FlickrClient.JSONResponseKeys.secret] as! String
            let id = item[FlickrClient.JSONResponseKeys.id] as! String
            photo.url = "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret).jpg"
            
            pin.addToPhotos(photo)
            
        }
        return true
        
        
    }
    
    
    private func parsePhotoResults(result: AnyObject?) -> [String: AnyObject]? {
        if let result = result as? [String: AnyObject] {
            return result[FlickrClient.JSONResponseKeys.photoBodyKey] as? [String:AnyObject]
        }
        return nil
    }
    
}
