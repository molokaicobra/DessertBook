//
//  RecipeAPI.swift
//  DessertBook
//
//  Created by Cobra Curtis on 6/20/24.
//

import Foundation

/**
 A class responsible for fetching and decoding recipes from the API.
 
 This class conforms to the `RecipeAPIProtocol` and provides methods to fetch a list of recipes,
 fetch a specific recipe by ID, and decode JSON responses into custom Recipe Structures.
 - SeeAlso: RecipeStructures
 */
class RecipeAPI: RecipeAPIProtocol {
    
    /**
     Fetches the list of dessert recipes from the API endpoint: https://www.themealdb.com/api/json/v1/1/filter.php?c=Dessert.
     
     - Returns: A `Data` object containing the JSON response.
     - Throws:
         - `NetworkError.invalidURL`: If the API URL is invalid.
         - `NetworkError.invalidResponse`: If the API response is not as expected.
         - `NetworkError.invalidData`: If the data received from the API is invalid.
         - `NetworkError.badRequest`: If the API request is malformed or incorrect.
         - `NetworkError.decodingError`: If there is an error decoding the JSON from the API.
         - `NetworkError.notConnected`: If there is no network connection
     - 
     */
    func getRecipesList() async throws -> Data {
        // API endpoint
        let urlString = "https://www.themealdb.com/api/json/v1/1/filter.php?c=Dessert"
        // Use getDataFromURL to fetch the data
        let jsonData = try await getDataFromURL(from: urlString)
        return jsonData
    }
    
    /**
     Decodes the JSON data into an array of `ShortHandMeal` objects.
     
     - Parameter recipeListData: The JSON data to decode.
     - Returns: An array of `ShortHandMeal` objects.
     - Throws:
         - `NetworkError.decodingError`: if decoding fails.
     */
    func decodeRecipesList(recipeListData: Data) throws -> [ShortHandMeal] {
        do {
            let shortHandResponse = try JSONDecoder().decode(ShortHandResponse.self, from: recipeListData)
            return shortHandResponse.meals
        } catch {
            throw NetworkError.decodingError
        }
    }

    /**
     Decodes the JSON data into a `Recipe` object.
     
     - Parameter recipeData: The JSON data to decode.
     - Returns: A `Recipe` object.
     - Throws:
         - `NetworkError.decodingError`: if decoding fails.
         - `NetworkError.invalidData`: if the list is empty
     */
    func decodeRecipe(recipeData: Data) throws -> Recipe {
        do {
            let decoder = JSONDecoder()
            let recipeResponse = try decoder.decode(RecipeResponse.self, from: recipeData)
            
            guard let recipe = recipeResponse.meals.first else {
                throw NetworkError.invalidData
            }
            
            return recipe
        } catch {
            throw NetworkError.decodingError
        }
    }
    
    /**
     Fetches a specific recipe from the API endpoint: https://www.themealdb.com/api/json/v1/1/lookup.php?i=(recipeID).
     
     - Parameter recipeID: The ID of the recipe to fetch.
     - Returns: A `Data` object containing the JSON response.
     - Throws:
         - `NetworkError.invalidURL`: If the API URL is invalid.
         - `NetworkError.invalidResponse`: If the API response is not as expected.
         - `NetworkError.invalidData`: If the data received from the API is invalid.
         - `NetworkError.badRequest`: If the API request is malformed or incorrect.
         - `NetworkError.notConnected`: If there is no network connection
     */
    func getRecipe(recipeData recipeID: String) async throws -> Data {
        let endpoint = "https://www.themealdb.com/api/json/v1/1/lookup.php?i=\(recipeID)"
        let jsonData = try await getDataFromURL(from: endpoint)
        return jsonData
    }
    
    /**
     Helper function to fetch JSON data from a URL.
     
     - Parameter endpoint: The URL string of the API endpoint.
     - Returns: A `Data` object containing the JSON response.
     - Throws:
         - `NetworkError.invalidURL`: If the API URL is invalid.
         - `NetworkError.invalidResponse`: If the API response is not as expected.
         - `NetworkError.invalidData`: If the data received from the API is invalid.
         - `NetworkError.badRequest`: If the API request is malformed or incorrect.
         - `NetworkError.notConnected`: If there is no network connection
     */
    func getDataFromURL(from endpoint: String) async throws -> Data {
        guard let url = URL(string: endpoint) else {
            throw NetworkError.invalidURL
        }
        
        do {
            //Make a URL request
            let request = URLRequest(url: url, timeoutInterval: 10) // Set timeout interval
            let (jsonData, response) = try await URLSession.shared.data(for: request)
            
            //Catches invalid httResponses
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                throw NetworkError.invalidResponse
            }
            
            return jsonData
        } catch let error as URLError {
            switch error.code {
            case .timedOut:
                throw NetworkError.badRequest
            case .notConnectedToInternet:
                throw NetworkError.notConnected
            default:
                throw NetworkError.unknown(error)
            }
        } catch {
            throw NetworkError.unknown(error)
        }
    }
}
