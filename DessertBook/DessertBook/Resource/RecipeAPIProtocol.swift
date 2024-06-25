//
//  RecipeAPIProtocol.swift
//  DessertBook
//
//  Created by Cobra Curtis on 6/23/24.
//

import Foundation

/**
    A protocol that defines the componets that are used in a RecipeAPIProtocol. This protocol was created so that we could use it in future expansions of the app and for dependncy injection.
 */
protocol RecipeAPIProtocol {
    
    // MARK: - Network Calls
    
    /**
     Retrieves a list of recipes from the API.
     
     This method makes a network call to fetch the list of recipes asynchronously.
     
     - Returns: A `Data` object containing the response from the API from the web socket: https://www.themealdb.com/api/json/v1/1/filter.php?c=Dessert
     - throws:
         - `NTError.invalidURL`: If the API URL is invalid.
         - `NTError.invalidResponse`: If the API response is not as expected.
         - `NTError.invalidData`: If the data received from the API is invalid.
         - `NTError.badRequest`: If the API request is malformed or incorrect.
         - `NTError.decodingError`: If there is an error decoding the JSON from the API.
     */
    func getRecipesList() async throws -> Data
    
    /**
     Retrieves the details of a specific recipe from the API.
     
     This method makes a network call to fetch the details of a specific recipe asynchronously.
     
     - Parameter recipeData: A `String` containing the necessary data to identify the recipe.
     - Returns: A `Data` object containing the raw JSON from the web socket: https://www.themealdb.com/api/json/v1/1/lookup.php?i=(recipeData).
     - throws:
         - `NTError.invalidURL`: If the API URL is invalid.
         - `NTError.invalidResponse`: If the API response is not as expected.
         - `NTError.invalidData`: If the data received from the API is invalid.
         - `NTError.badRequest`: If the API request is malformed or incorrect.
     */
    func getRecipe(recipeData: String) async throws -> Data
    
    /**
     Retrieves data from a given URL.
     
     This method makes a network call to fetch data from a specified URL asynchronously.
     
     - Parameter urlString: A `String` representing the URL to fetch data from.
     - Returns: A `Data` object containing the  response from the specified URL.
     - throws:
         - `NTError.invalidURL`: If the API URL is invalid.
         - `NTError.invalidResponse`: If the API response is not as expected.
         - `NTError.invalidData`: If the data received from the API is invalid.
         - `NTError.badRequest`: If the API request is malformed or incorrect.
     */
    func getDataFromURL(from urlString: String) async throws -> Data
    
    // MARK: - Decoders
    
    /**
     Decodes a list of recipes from the provided data.
     
     This method decodes the raw `Data` object into an array of `ShortHandMeal` objects.
     
     - Parameter recipeListData: A `Data` object containing the raw data to decode.
     - Returns: An array of `ShortHandMeal` objects.
     - Throws: An error if the decoding process fails.
         - `NTError.decodingError`: If there is an error decoding the JSON from the API.
     - SeeAlso: RecipeStructures
     */
    func decodeRecipesList(recipeListData: Data) throws -> [ShortHandMeal]
    
    /**
     Decodes a specific recipe from the provided data.
     
     This method decodes the  `Data` object into a `Recipe` object.
     
     - Parameter recipeData: A `Data` object containing the raw data to decode.
     - Returns: A `Recipe` object.
     - Throws: An error if the decoding process fails.
         - `NTError.decodingError`: If there is an error decoding the JSON from the API.
     - SeeAlso: RecipeStructures
     */
    func decodeRecipe(recipeData: Data) throws -> Recipe
}

