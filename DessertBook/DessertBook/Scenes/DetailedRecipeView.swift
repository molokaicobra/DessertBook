//
//  DetailedRecipeView.swift
//  DessertBook
//
//  Created by Cobra Curtis on 6/20/24.
//

import Foundation
import SwiftUI

/**
 Provides a detailed view of the recipe that the user selected. This provides them with a formated view of the recipe image, instructions, name, ingredients and measurements
 This method view uses API calls from its View Model. This API call gets a custom struct called 'Recipe' and is located in the 'RecipeStructres' class.
 
 This structer is a decoded version of the JSONData that is recived from the API endpoint:  https://www.themealdb.com/api/json/v1/1/lookup.php?i=(selectRecipeID)
 - SeeAlSO: RecipeStructures, DetailedRecipeViewModel
 - Note: This is async from our calls to our view model.
 */
//TODO: add a way to view and watch youtube videos and incoporate the rest of the data into the view.
struct DetailedRecipeView: View {
    let selectedRecipeID: String
    let selectedRecipeName: String
    @StateObject private var viewModel = DetailedRecipeViewModel() //This init is using a default value of the class 'RecipeAPI'. If you want to use a differnt or mock api for dependency injection please note that.

    /**
     Initializes the view with the selected recipe ID and name.
     - Parameters:
       - selectedRecipeID: The ID of the selected recipe. This is used to make later API calls that are requried to get the exact recipe
       - selectedRecipeName: The name of the selected recipe. This is so we can have the title follow the view as the user scrolls down.
     */
    init(selectedRecipeID: String, selectedRecipeName: String) {
        self.selectedRecipeID = selectedRecipeID
        self.selectedRecipeName = selectedRecipeName
    }
    
    // creates the main view for the recipe and positions the data that we are using. The image, instructions, name, and ingredients and measurements.
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if let recipe = viewModel.recipe {
                    // Image view for the recipe
                    if let imageUrl = URL(string: recipe.strMealThumb) {
                        HStack {
                            Spacer()
                            CachedAsyncImage(url: imageUrl) { image in
                                image?
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 300)
                            }
                            .accessibilityIdentifier("picture of dessert")
                            Spacer()
                        }
                    }

                    // Name label for the recipe
                    Text(recipe.strMeal.capitalized)
                        .font(.title)
                        .bold()
                        .padding([.leading, .trailing, .top])
                        .accessibilityIdentifier("mealLabel")

                    // Ingredients and measurements text view. Zips the ingredients and measurements into a single object so that we can display them together. This also matches each in ingredient with its proper measurement.
                    let ingredientsAndMeasurements = zip(recipe.ingredients, recipe.measurements)
                        .map { "\($0.0): \($0.1)" }
                        .joined(separator: "\n")
                    let formattedContent = "Ingredients:\n\n\(ingredientsAndMeasurements)"
                    Text(formattedContent)
                        .padding([.leading, .trailing, .top])
                        .accessibilityIdentifier("IngredientsAndMeasurements")

                    // Instructions text view
                    Text("Instructions:\n\n\(recipe.strInstructions)")
                        .padding([.leading, .trailing, .top, .bottom])
                        .accessibilityIdentifier("Instructions")
                } else {
                    Text("Loading...") //Temp view
                        .padding([.leading, .trailing, .top, .bottom])
                }
            }
        }
        .navigationTitle(self.selectedRecipeName)
        .accessibilityIdentifier("detailedRecipeView")
        .task {
            await viewModel.fetchRecipe(selectedRecipe: selectedRecipeID) //Call to our viewModel to populate the screen. This is async 
        }
        .alert(item: $viewModel.error) { error in
            Alert(title: Text("Error"), message: Text(error.localizedDescription))
        }
    }
}

/**
 ViewModel to handle the fetching and state of the DetailedRecipeView.
 
 - Note: This method is async and throws
 - throws:
 - `NTError.invalidURL`: If the API URL is invalid.
 - `NTError.invalidResponse`: If the API response is not as expected.
 - `NTError.invalidData`: If the data received from the API is invalid.
 - `NTError.badRequest`: If the API request is malformed or incorrect.
 - `NTError.decodingError`: If there is an error decoding the JSON from the API.
 */
@MainActor
class DetailedRecipeViewModel: ObservableObject {
    @Published var recipe: Recipe? // Published property to hold the recipe data
    @Published var error: NetworkError? // Published property to hold any error that occurs
    
    let recipeAPICaller: RecipeAPIProtocol // Protocol to handle API calls. A protocol was created incase we want to expand to make more or differnt recipeAPIs in the future, such as mock recipes or other endpoints.
    
    /**
     Initializes the view model with a recipe API caller.
     - Parameter recipeAPICaller: The API caller protocol to fetch recipes, defaults to an instance of the current RecipeAPI.
     */
    init(recipeAPICaller: RecipeAPIProtocol = RecipeAPI()) {
        self.recipeAPICaller = recipeAPICaller
    }
    
    /**
     Fetches the recipe based on the selected recipe ID from the previous RecipeTableView.
     - Parameter selectedRecipe: The ID of the selected recipe.
     - Returns: A 'Recipe' strucutre from 'RecipeStructures'
     - SeeAlSO: RecipeStructures, and RecipeAPI
     */
    func fetchRecipe(selectedRecipe: String) async {
        do {
            // Fetch and decode the recipe data
            let jsonData = try await recipeAPICaller.getRecipe(recipeData: selectedRecipe)
            self.recipe = try recipeAPICaller.decodeRecipe(recipeData: jsonData)
        } catch let error as NetworkError {
            // Handle known network errors
            self.error = error
            print("A network error occurred: \(error)") // TODO: Improve error logging
        } catch {
            // Handle unknown errors
            let networkError = NetworkError.unknown(error)
            self.error = networkError
            print("An unknown error occurred: \(networkError)") // TODO: Improve error logging
        }
    }
}

