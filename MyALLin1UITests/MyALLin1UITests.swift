//
//  MyALLin1UITests.swift
//  MyALLin1UITests
//
//  Created by Alex Mills on 22/3/20.
//  Copyright © 2020 MyALLin1. All rights reserved.
//

import XCTest

class MyALLin1UITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

//    func testExample() {
//        // UI tests must launch the application that they test.
//        let app = XCUIApplication()
//        app.launch()
//
//        // Use recording to get started writing UI tests.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//    }
//
//    func testLaunchPerformance() {
//        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
//            // This measures how long it takes to launch your application.
//            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
//                XCUIApplication().launch()
//            }
//        }
//    }
    
    func testMapLocation () {
        let app = XCUIApplication()
        app.launch()
        //Tap the map button
        XCUIApplication().tabBars.buttons["Map"].tap()
        //Tap the location of user
        XCUIApplication().otherElements["My Location"].tap()
        //Confirm location exists
        XCTAssertTrue(app.otherElements["My Location"].exists)
    }
    
    func testAddDealCategory() {
        let app = XCUIApplication()
        app.launch()
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
        let app = XCUIApplication()
        testAddDealCategory()
        let tablesQuery = XCUIApplication().tables
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["TEST"]/*[[".cells.staticTexts[\"TEST\"]",".staticTexts[\"TEST\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeLeft()
        tablesQuery/*@START_MENU_TOKEN@*/.buttons["trailing0"]/*[[".cells",".buttons[\"Delete\"]",".buttons[\"trailing0\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        XCTAssertFalse(app.tables.staticTexts["TEST"].exists)
    }
}
