//
//  MyALLin1UITests.swift
//  MyALLin1UITests
//
//  Created by Alex Mills on 22/3/20.
//  Copyright © 2020 MyALLin1. All rights reserved.
//

import XCTest

class MyALLin1UITests: XCTestCase {
    
    var app = XCUIApplication()
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launch()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testMapLocation () {
        //Tap the map button
        XCUIApplication().tabBars.buttons["Map"].tap()
        
        //Access springbard to interact with location services permissions prompt
        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        let allowBtn = springboard.buttons["Allow Once"]
        if allowBtn.exists {
            allowBtn.tap()
        }
        
        //Tap the location of user
        XCUIApplication().otherElements["My Location"].tap()
        //Confirm location exists
        XCTAssertTrue(app.otherElements["My Location"].exists)
    }
    
    func testAddDealCategory() {
        //tap the deals button
        app.tabBars.buttons["Deals"].tap()
        //tap the + button to bring up the deal list screen
        app.buttons["+"].tap()
        //tap the + button to bring up the add deal alert box
        app.navigationBars["eBay Categories"].buttons["Add"].tap()
        //reference to alert window for adding new category
        let elementsQuery = app.alerts["Add Category"].scrollViews.otherElements
        //Type test and tap "add" to add new category
        elementsQuery.textFields.element.typeText("TEST")
        elementsQuery.buttons["Add"].tap()
        //sleep to allow API to retrieve products
        sleep(5)
        //Check category is displayed in the category list
        XCTAssertTrue(app.tables.staticTexts["TEST"].exists)
    }
    
    func testDeleteDealCategory(){
        //tap the deals button
        app.tabBars.buttons["Deals"].tap()
        //tap the + button to bring up the deal list screen
        app.buttons["+"].tap()
        //tap the + button to bring up the add deal alert box
        app.navigationBars["eBay Categories"].buttons["Add"].tap()
        //reference to alert window for adding new category
        let elementsQuery = app.alerts["Add Category"].scrollViews.otherElements
        //add a new category to delete
        elementsQuery.textFields.element.typeText("TODELETE")
        elementsQuery.buttons["Add"].tap()
        //sleep to allow API to retrieve products
        sleep(5)
        let tablesQuery = XCUIApplication().tables
        //find the category we just added and delete it
        tablesQuery.staticTexts["TODELETE"].swipeLeft()
        tablesQuery/*@START_MENU_TOKEN@*/.buttons["trailing0"]/*[[".cells",".buttons[\"Delete\"]",".buttons[\"trailing0\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        //confirm category has been removed from table
        XCTAssertFalse(app.tables.staticTexts["TODELETE"].exists)
    }
}
