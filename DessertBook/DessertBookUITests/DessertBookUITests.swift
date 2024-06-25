//
//  DessertBookUITests.swift
//  DessertBookUITests
//
//  Created by Cobra Curtis on 6/20/24.
//

import XCTest

class DessertBookUITests: XCTestCase {
    
    //Setup the app for testing
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        continueAfterFailure = false

        let app = XCUIApplication()
        app.launch()
    }

    /*
     Test the main menu, ensure that the button and text is loading, and that we are transitioning to the RecipeTableView when we click next.
     */
    func testMainMenuUIElements() throws {
        let app = XCUIApplication()

        // Check if the title label exists and contains the correct text
        let titleLabel = app.staticTexts["titleLabel"]
        XCTAssertTrue(titleLabel.exists, "The title label should exist")
        XCTAssertEqual(titleLabel.label, "Pocket Cookbook", "The title label should display 'Pocket Cookbook'")

        // Check if the button exists and contains the correct text
        let nextButton = app.buttons["nextButton"]
        XCTAssertTrue(nextButton.exists, "The next button should exist")
        XCTAssertEqual(nextButton.label, "View Desserts", "The button should display 'View Desserts'")

        // Tap the button and verify navigation
        nextButton.tap()

        // Wait for the RecipeTableView to appear
        let recipeTableView = app.collectionViews["recipeTableView"]



        XCTAssertTrue(recipeTableView.exists, "The app should navigate to RecipeTableView after tapping the button")
    }
    
    /*
     Checks that the main UI elements of the RecipeTableView are loading when we transition to it from the MainMenu. Makes sure that we are able to scroll and transition to a selected recipe that is located in the list and the DetailedRecipeView.
     */
    func testRecipeTableViewUIElements() throws {
        let app = XCUIApplication()

        // Navigate to RecipeTableView
        let nextButton = app.buttons["nextButton"]
        XCTAssertTrue(nextButton.exists, "The next button should exist")
        nextButton.tap()

        // Verify the RecipeTableView is displayed
        let recipeTableView = app.collectionViews["recipeTableView"]
        XCTAssertTrue(recipeTableView.exists, "The RecipeTableView should exist")

        //Check that we can scroll and entities are loading
        recipeTableView.swipeUp()
        
        
        // Assuming the recipes are already loaded for testing purposes
        // Check for a specific recipe in the list
        let recipeName = "Carrot Cake"
        let recipeRow = recipeTableView.buttons[recipeName]
        XCTAssertTrue(recipeRow.exists, "The recipe '\(recipeName)' should be in the list")

        // Tap on the recipe row to navigate to DetailedRecipeView
        recipeRow.tap()

        // Verify the DetailedRecipeView is displayed
        let detailedRecipeView = app.scrollViews["detailedRecipeView"]
        XCTAssertTrue(detailedRecipeView.exists, "The DetailedRecipeView should exist after tapping a recipe")
    }

    /*
     Checks that the details of a recipe are loaded once we trainstion to it from the RecipeTableView. This checks that the name, ingridentsAndMeasurements, and pictures all exist.
     */
    func testDetailedRecipeViewUIElements() throws {
        let app = XCUIApplication()

        // Navigate to RecipeTableView
        let nextButton = app.buttons["nextButton"]
        XCTAssertTrue(nextButton.exists, "The next button should exist")
        nextButton.tap()

        // Assuming the recipes are already loaded for testing purposes
        // Check for a specific recipe in the list (e.g., "Chocolate Cake")
        let recipeName = "Apam Balik" // Change this to an actual recipe name from your test data
        let recipeRow = app.staticTexts[recipeName]
        XCTAssertTrue(recipeRow.exists, "The recipe '\(recipeName)' should be in the list")

        // Tap on the recipe row to navigate to DetailedRecipeView
        recipeRow.tap()

        // Verify the DetailedRecipeView is displayed
        let detailedRecipeView = app.scrollViews["detailedRecipeView"]
        XCTAssertTrue(detailedRecipeView.exists, "The DetailedRecipeView should exist after tapping a recipe")

        // Verify the key elements in the DetailedRecipeView
        let mealLabel = app.staticTexts["mealLabel"]
        XCTAssertTrue(mealLabel.exists, "The meal label should exist")

        let ingredientsAndMeasurements = app.staticTexts["IngredientsAndMeasurements"]
        XCTAssertTrue(ingredientsAndMeasurements.exists, "The ingredients and measurements text view should exist")

        let instructions = app.staticTexts["Instructions"]
        XCTAssertTrue(instructions.exists, "The instructions text view should exist")

        let dessertImage = app.images["picture of dessert"]
        XCTAssertTrue(dessertImage.exists, "The image of the dessert should exist")
    }
}
