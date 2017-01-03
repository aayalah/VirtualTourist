//
//  Photo+CoreDataProperties.swift
//  VirtualTourist2
//
//  Created by Alejandro Ayala-Hurtado on 1/2/17.
//  Copyright © 2017 MobileApps. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo");
    }

    @NSManaged public var photo: NSData?
    @NSManaged public var url: String?
    @NSManaged public var pin: Pin?

}
