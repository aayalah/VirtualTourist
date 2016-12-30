//
//  Photo+CoreDataProperties.swift
//  VirtualTourist2
//
//  Created by Alejandro Ayala-Hurtado on 12/29/16.
//  Copyright © 2016 MobileApps. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo");
    }

    @NSManaged public var photo: String?
    @NSManaged public var url: String?
    @NSManaged public var pin: Pin?

}
