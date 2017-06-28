//
//  iMindYouUITests.swift
//  iMindYouUITests
//
//  Created by Rajagopal on 6/23/17.
//  Copyright © 2017 Rajagopal. All rights reserved.
//

import XCTest

class iMindYouUITests: XCTestCase {
    
    var app : XCUIApplication!
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app = XCUIApplication()
        
        // We send a command line argument to our app,
        // to enable it to reset its state
        app.launchArguments.append("--uitesting")

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: Tests
    
    func testAppLoadsWithoutFailure() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        app.launch()
        
        // Make sure we're displaying the reminders screen
        let appTitle = app.staticTexts["Reminders"]
        XCTAssertTrue(appTitle.exists)
        let addButton = app.navigationBars["Reminders"].buttons["Add"]
        XCTAssertTrue(addButton.exists)
    }
    
    func testAppLoadsWith0DefaultRemindersInView() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        app.launch()
        
        // Make sure we're displaying the reminders screen
        let appTitle = app.staticTexts["Reminders"]
        XCTAssertTrue(appTitle.exists)
        let allCells = app.tables.cells
        XCTAssertEqual(allCells.count, 0, "There should be no reminders initially")
    }
    
    func testAppOnClickingAddTakesToNewReminderPage() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        app.launch()
        
        // Make sure we're displaying the reminders screen 
        
        let addButton = app.navigationBars["Reminders"].buttons["Add"]
        XCTAssertTrue(addButton.exists)
        addButton.tap()
        
        let pageTitle = app.staticTexts["New Reminder"]
        XCTAssertNotNil(pageTitle)
    }
    
    func testAppOnClickingCancelInNewRemindersScreen_ShouldNotAddAnyReminder_Navigation() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        app.launch()
        
        // Make sure we're displaying the reminders screen 
        
        let addButton = app.navigationBars["Reminders"].buttons["Add"]
        
        var allCells = app.tables.cells
        XCTAssertEqual(allCells.count, 0, "There should be no reminders initially")

        addButton.tap()
        
        let pageTitle = app.staticTexts["New Reminder"]
        XCTAssertTrue(pageTitle.exists)
        
        let cancelButton = app.navigationBars["New Reminder"].buttons["Cancel"]
        XCTAssertTrue(cancelButton.exists)
        cancelButton.tap()
        
        let appTitle = app.staticTexts["Reminders"]
        XCTAssertTrue(appTitle.exists)
        allCells = app.tables.cells
        XCTAssertEqual(allCells.count, 0, "There should be no reminders after cancel")

    }
    
    func testAppOnClickingSaveInNewRemindersScreen_ShouldAddNewReminder_Navigation() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        app.launch()
        
        // Make sure we're displaying the reminders screen 
        
        let addButton = app.navigationBars["Reminders"].buttons["Add"]
        
        var allCells = app.tables.cells
        XCTAssertEqual(allCells.count, 0, "There should be no reminders initially")
        
        addButton.tap()
        
        let pageTitle = app.staticTexts["New Reminder"]
        XCTAssertTrue(pageTitle.exists)
        
        let reminderTitleTextField = app.textFields["Reminder Title"]
        reminderTitleTextField.tap()
        reminderTitleTextField.tap()
        reminderTitleTextField.typeText("Reminder1")
        
        let remdescriptionTextView = app.textViews["remDescription"]
        remdescriptionTextView.tap()
        remdescriptionTextView.tap()
        remdescriptionTextView.typeText("description")
        

        
        let saveButton = app.navigationBars["New Reminder"].buttons["Save"]
        XCTAssertTrue(saveButton.exists)
        saveButton.tap()
        
        let appTitle = app.staticTexts["Reminders"]
        XCTAssertTrue(appTitle.exists)
        allCells = app.tables.cells
        XCTAssertEqual(allCells.count, 1, "There should be 1 reminders after save")
        
        let newCell = allCells.containing(.staticText, identifier:"Title : Reminder1").staticTexts["Description : description"]
        XCTAssertTrue(newCell.exists)
        
    }
    
    func testShouldNavigateToEditItemPageOnClickingItem() {
        app.launch()
        let addButton = app.navigationBars["Reminders"].buttons["Add"]
        addButton.tap()
        
        var reminderTitleTextField = app.textFields["Reminder Title"]
        reminderTitleTextField.tap()
        reminderTitleTextField.tap()
        reminderTitleTextField.typeText("Item1")
        
        let remdescriptionTextView = app.textViews["remDescription"]
        remdescriptionTextView.tap()
        remdescriptionTextView.tap()
        remdescriptionTextView.typeText("description")
        
        
        let saveButton = app.navigationBars["New Reminder"].buttons["Save"]
        XCTAssertTrue(saveButton.exists)
        saveButton.tap()
        
        let appTitle = app.staticTexts["Reminders"]
        XCTAssertTrue(appTitle.exists)
        
        let allCells = app.tables.cells
        var newCell = allCells.containing(.staticText, identifier:"Title : Item1").staticTexts["Description : description"]
        XCTAssertTrue(newCell.exists)
        
        newCell.tap()
        XCTAssertTrue(app.navigationBars["Item1"].exists)
        
        reminderTitleTextField = app.textFields["Reminder Title"]
        XCTAssertEqual(reminderTitleTextField.value as! String, "Item1")
        reminderTitleTextField.tap()
        reminderTitleTextField.typeText("New")
        
        app.navigationBars["Item1"].buttons["Save"].tap()
        
        newCell = allCells.containing(.staticText, identifier:"Title : Item1New").staticTexts["Description : description"]
        XCTAssertTrue(newCell.exists)
    }
    
    func testShouldBeAbleToDeleteTheAddedItem() {
        
        app.launch()
        let addButton = app.navigationBars["Reminders"].buttons["Add"]
        addButton.tap()
        
        let reminderTitleTextField = app.textFields["Reminder Title"]
        reminderTitleTextField.tap()
        reminderTitleTextField.tap()
        reminderTitleTextField.typeText("Reminder1")
        
        let remdescriptionTextView = app.textViews["remDescription"]
        remdescriptionTextView.tap()
        remdescriptionTextView.tap()
        remdescriptionTextView.typeText("description")
       
        
        let saveButton = app.navigationBars["New Reminder"].buttons["Save"]
        XCTAssertTrue(saveButton.exists)
        saveButton.tap()

        let appTitle = app.staticTexts["Reminders"]
        XCTAssertTrue(appTitle.exists)
        
        app.navigationBars["Reminders"].buttons["Edit"].tap()
        
        let allCells = app.tables.cells
        var newCell = allCells.containing(.staticText, identifier:"Title : Reminder1").staticTexts["Description : description"]
        XCTAssertTrue(newCell.exists)

        let predicateNewItem = NSPredicate(format: "label BEGINSWITH 'Delete Title : Reminder1'")
        let itemToDelete = allCells.buttons.element(matching: predicateNewItem)
        XCTAssertTrue(itemToDelete.exists)
        itemToDelete.tap()
        XCTAssertTrue(allCells.buttons["Delete"].exists)
        allCells.buttons["Delete"].tap()
        
        newCell = allCells.containing(.staticText, identifier:"Title : Reminder1").staticTexts["Description : description"]
        XCTAssertFalse(newCell.exists)
        
         XCTAssertEqual(allCells.count, 0, "There should be no reminders after delete")
        
    }
    
    func testShouldDisplayNoRemindersMessageIfEmpty() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        app.launch()
        
        // Make sure we're displaying the reminders screen 
        
        let addButton = app.navigationBars["Reminders"].buttons["Add"]
        XCTAssertTrue(addButton.exists)
        addButton.tap()
        
        let emptyMessage = app.staticTexts["No Reminders to list!"]
        XCTAssertNotNil(emptyMessage.exists)
    }
    
}
