//
//  SavedLocation+CoreDataProperties.swift
//  MyALLin1
//
//  Created by Erin Carroll on 11/4/20.
//  Copyright © 2020 MyALLin1. All rights reserved.
//
//

import Foundation
import CoreData


extension SavedLocation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedLocation> {
        return NSFetchRequest<SavedLocation>(entityName: "SavedLocation")
    }

    @NSManaged public var name: String?
    @NSManaged public var country: String?
    @NSManaged public var longitude: Double
    @NSManaged public var latitude: Double

}
