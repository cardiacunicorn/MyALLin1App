//
//  DealCategory+CoreDataProperties.swift
//  MyALLin1
//
//  Created by Chris Bowe on 17/4/20.
//  Copyright © 2020 MyALLin1. All rights reserved.
//
//

import Foundation
import CoreData


extension DealCategory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DealCategory> {
        return NSFetchRequest<DealCategory>(entityName: "DealCategory")
    }

    @NSManaged public var name: String?

}
