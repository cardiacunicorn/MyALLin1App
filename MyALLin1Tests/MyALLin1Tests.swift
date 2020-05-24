//
//  MyALLin1Tests.swift
//  MyALLin1Tests
//
//  Created by Alex Mills on 22/3/20.
//  Copyright © 2020 MyALLin1. All rights reserved.
//

import XCTest
import CoreData
@testable import MyALLin1

class MyALLin1Tests: XCTestCase {

    var context:NSManagedObjectContext?
    let sutWeatherLocations = SavedLocationManager()
    let sutDealCategories = DealCategoryManager()
    
    override func setUp() {
        context = setUpInMemoryManagedObjectContext()
        sutWeatherLocations.managedContext = self.context!
        sutDealCategories.managedContext = self.context!
        setUpObjects()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
    func testFetchSavedLocations(){
        let locations = sutWeatherLocations.fetchSavedLocations()
        XCTAssertEqual(locations.count, 1)
    }
    
    func testAddSavedLocation(){
        let city = City(name: "Brisbane", country: "Australia", longitude: 153.021072, latitude: -27.470125)
        sutWeatherLocations.addSavedLocation(location: city)
        let locations = sutWeatherLocations.fetchSavedLocations()
        XCTAssertEqual(locations.count, 2)
    }
    
    func testDeleteSavedLocation(){
        var locations = sutWeatherLocations.fetchSavedLocations()
        let location = locations.first
        sutWeatherLocations.deleteSavedLocation(savedLocation: location!)
        locations = sutWeatherLocations.fetchSavedLocations()
        XCTAssertEqual(locations.count, 0)
    }
    
    func setUpObjects(){
        if let context = self.context {
            // Create saved location object
            let newLocation = SavedLocation(context: context)
            newLocation.name = "Melbourne"
            newLocation.country = "Australia"
            newLocation.longitude = 144.9633179
            newLocation.latitude = -37.8139992
        } else {
            print("Error: Missing Context")
        }
    }
    
    // Test adding a new deal category to the database
    func testAddDealCategory() {
        sutDealCategories.addDealCategory("Test category")
        let dealCount = sutDealCategories.getCategoryCount()
        XCTAssertEqual(dealCount, 1)
    }
    
    // Test deleting deal category from the database
    func testDeleteDealCategory() {
        testAddDealCategory()
        let deals = sutDealCategories.getCategoryList()
        let deal = deals.first
        sutDealCategories.deleteDealCategory(dealCategory: deal!)
        let dealCount = sutDealCategories.getCategoryCount()
        XCTAssertEqual(dealCount, 0)
    }
    
    // Set-up "mock" persistent store and context for use in testing Core Data implementation(s)
    // Source: https://github.com/lukecsmith/CoreDataUnitTests/blob/master/CoreDataUnitTestsTests/UnitTestHelpers.swift
    func setUpInMemoryManagedObjectContext() -> NSManagedObjectContext {
        
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        } catch {
            fatalError("Adding in-memory persistent store failed")
        }
        
        let context = NSManagedObjectContext.init(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentStoreCoordinator
        
        return context
    }
}

