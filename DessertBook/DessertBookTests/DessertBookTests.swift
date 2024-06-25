//
//  DessertBookTests.swift
//  DessertBookTests
//
//  Created by Cobra Curtis on 6/20/24.
//

import XCTest
@testable import DessertBook

// Test class for RecipeTableViewModel
class RecipeTableViewModelTests: XCTestCase {
    var mockNetworkAPI: MockNetworkConnetion!
    var recipeAPI: RecipeAPIProtocol!
    
    override func setUp() {
        super.setUp()
        mockNetworkAPI = MockNetworkConnetion()
        recipeAPI = RecipeAPI()
    }
    
    //MARK: Test methods for getRecipesList
    
    /*
     Test if the decoder is properly decoding the the list of desserts with known good recipes
     */
    func testGetRecipesListSuccess() async {
        mockNetworkAPI.shouldReturnError = false
        do {
            //TODO: improve this test, right now it's checking for a hardcoded 65 but there should be a way to change this. Example, what if a recipe is added or removed? Maybe remove this test all together and just ensure we are getting more then 1 response
            let meals = try recipeAPI.decodeRecipesList(recipeListData: mockNetworkAPI.getRecipesListTestData())
            XCTAssertEqual(meals.count, 65)
            let recipeOne = meals.first
            let recipeTwo = meals.last
            XCTAssertEqual(recipeOne?.id, "53049")
            XCTAssertEqual(recipeOne?.name, "Apam balik")
            XCTAssertEqual(recipeTwo?.id, "52917")
            XCTAssertEqual(recipeTwo?.name, "White chocolate creme brulee")
        } catch {
            XCTFail("Expected success but got error: \(error)")
        }
    }
    
    /*
     Test if the decoder is properly catching that the data that is being passed into it is empty
     */
    func testGetRecipesListInvalidData() async {
        // Arrange: Set up the mock API to return an error
        mockNetworkAPI.shouldReturnError = true
        mockNetworkAPI.error = NetworkError.invalidData
        
        do {
            // Act: Call decodeRecipesList with mock data that triggers an invalid response
            let data = try recipeAPI.decodeRecipesList(recipeListData: mockNetworkAPI.getRecipeTestData())
            
            // Assert: If the function did not throw an error, fail the test
            XCTFail("Expected NetworkError.invalidData, but no error was thrown")
        } catch NetworkError.invalidData {
            // Assert: The correct error was thrown, test passes
            XCTAssertTrue(true, "NetworkError.invalidResponse was thrown as expected")
        } catch {
            // Assert: Any unexpected error should fail the test
            XCTFail("Unexpected error thrown: \(error)")
        }
    }
    
    
    /*
     Test if the decoder is properly catching that the data being passed inti it is malformed (Missing entries)
     */
    func testGetRecipesListDecodingError() async {
        // Arrange: Set up the mock API to return an error
        mockNetworkAPI.shouldReturnError = true
        mockNetworkAPI.error = NetworkError.decodingError
        
        do {
            // Act: Call decodeRecipesList with mock data that triggers a decoding error
            _ = try recipeAPI.decodeRecipesList(recipeListData: mockNetworkAPI.getRecipesListTestData())
            
            // Assert: If the function did not throw an error, fail the test
            XCTFail("Expected NetworkError.decodingError, but no error was thrown")
        } catch NetworkError.decodingError {
            // Assert: The correct error was thrown, test passes
            XCTAssertTrue(true, "NetworkError.decodingError was thrown as expected")
        } catch {
            // Assert: Any unexpected error should fail the test
            XCTFail("Unexpected error thrown: \(error)")
        }
    }
    
    
    
    //MARK: Test methods for getRecipe
    
    /*
     Test if the decoder is proplery decoding a known good recipe
     */
    func testGetRecipeSuccess() async {
        mockNetworkAPI.shouldReturnError = false
        do {
            let recipe = try recipeAPI.decodeRecipe(recipeData: mockNetworkAPI.getRecipeTestData())
            XCTAssertNotNil(recipe)
            XCTAssertEqual(recipe.idMeal, "52893")
            XCTAssertEqual(recipe.strMeal, "Apple & Blackberry Crumble")
            XCTAssertTrue(recipe.ingredients.count == 9)
            XCTAssertTrue(recipe.ingredients.count == recipe.measurements.count)
            
        } catch {
            XCTFail("Expected success but got error: \(error)")
        }
    }
    
    /*
     Test if the decoder is catching a malformed recipe (Missing it's name and ingridents)
     */
    func testGetRecipeDecodingError() async {
        // Arrange: Set up the mock API to return an error
        mockNetworkAPI.shouldReturnError = true
        mockNetworkAPI.error = NetworkError.decodingError
        
        do {
            // Act: Call decodeRecipe with mock data that triggers a decoding error
            _ = try recipeAPI.decodeRecipe(recipeData: mockNetworkAPI.getRecipeTestData())
            
            // Assert: If the function did not throw an error, fail the test
            XCTFail("Expected NetworkError.decodingError, but no error was thrown")
        } catch NetworkError.decodingError {
            // Assert: The correct error was thrown, test passes
            XCTAssertTrue(true, "NetworkError.decodingError was thrown as expected")
        } catch {
            // Assert: Any unexpected error should fail the test
            XCTFail("Unexpected error thrown: \(error)")
        }
    }
    
}

