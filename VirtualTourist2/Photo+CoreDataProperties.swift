//
//  Photo+CoreDataProperties.swift
//  VirtualTourist2
//
//  Created by Alejandro Ayala-Hurtado on 1/1/17.
//  Copyright © 2017 MobileApps. All rights reserved.
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo");
    }

    @NSManaged public var photo: String?
    @NSManaged public var url: NSData?
    @NSManaged public var pin: Pin?

}
