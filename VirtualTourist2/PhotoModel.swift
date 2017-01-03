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
    
    let context =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    func getPhotos(latitude: Double, longitude: Double, completionHandler: ((Bool) -> Void)? = nil) {
        
        
        
        FlickrClient.sharedInstance().getPhotosFromLocation(latitude: latitude, longitude: longitude, storeResult: storePhotos) { success, error in
            if let completionHandler = completionHandler {
                completionHandler(success)
            }
            
        }
        
    }
    
    private func storePhotos(longitude:Double, latitude: Double, result: AnyObject?) -> Bool {
        
        var pin = getPin(latitude: latitude, longitude: longitude)
        
        if pin == nil {
            
            
            let entity =  NSEntityDescription.entity(forEntityName: "Pin",
                                                     in:context)
            
            pin = NSManagedObject(entity: entity!,
                                      insertInto: context) as? Pin
            
            pin?.latitude = latitude
            pin?.longitude = longitude
            
        }
        
        
        if let photoResults = parsePhotoResults(result: result) {
            return addPhotosToContext(longitude: longitude, latitude: latitude, result: photoResults, pin: pin!)
        }

        
        return false
        
    }
    
    private func getPin(latitude: Double, longitude: Double) -> Pin? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Pin")
        let pinSort = NSSortDescriptor(key: "latitude", ascending: true)
        request.sortDescriptors = [pinSort]
        let epsilon = 0.000001
        request.predicate = NSPredicate(format: "(%K BETWEEN {\(latitude - epsilon), \(latitude + epsilon) }) AND (%K BETWEEN {\(longitude - epsilon), \(longitude + epsilon) })", "latitude", "longitude")
        
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try frc.performFetch()
            if (frc.fetchedObjects?.count)! > 0 {
                return frc.fetchedObjects?[0] as? Pin
            } else {
                return nil
            }
            
        } catch {
            
        }
        return nil
        
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
            print(photo.url!)
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
