//
//  SavedLocationManager.swift
//  MyALLin1
//
//  Created by Erin Carroll on 11/4/20.
//  Copyright © 2020 MyALLin1. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class SavedLocationManager {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var managedContext: NSManagedObjectContext
    
    // Fetch all saved locations from the database
    func fetchSavedLocations() -> [SavedLocation] {
        
        var locationsResult:[SavedLocation] = []
        
        let locationRequest: NSFetchRequest<SavedLocation> = SavedLocation.fetchRequest()
        
        do {
            locationsResult = try managedContext.fetch(locationRequest)
        } catch {
            print()
        }
        return locationsResult
    }
    
    // Add a location to the database from selected city search result
    func addSavedLocation(location: City){
        
        let newLocation = NSEntityDescription.insertNewObject(forEntityName: "SavedLocation", into: managedContext) as! SavedLocation
        
        newLocation.name = location.name
        newLocation.country = location.country
        newLocation.longitude = location.longitude
        newLocation.latitude = location.latitude
        
        appDelegate.saveContext()
    }
    
    // Delete a saved location from the database
    func deleteSavedLocation(savedLocation: SavedLocation){
        managedContext.delete(savedLocation)
        appDelegate.saveContext()
    }
    
    init(){
        managedContext = appDelegate.persistentContainer.viewContext
    }
}
