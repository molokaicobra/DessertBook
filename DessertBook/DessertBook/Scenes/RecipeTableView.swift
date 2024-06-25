//
//  RecipeTableView.swift
//  DessertBook
//
//  Created by Cobra Curtis on 6/20/24.
//

import SwiftUI
/**
 RecipeTableView: A view displaying a list of recipes. Each row contains an image of the recipe, and it's name. The user can click on the recipe and move to the detailed recipe view.
 This method view uses API calls from its View Model. This API call gets a custom struct called ShortHandResponse, which contains an array of ShortHandMeals. These ShortHandMeals contain:
 
 - SeeAlSO: RecipeStructures, RecipeTableViewModel
 - Note: This calls on async methods
*/
//TODO: Add a search, and favorites feature.
struct RecipeTableView: View {
    // StateObject to manage the view model
    @StateObject private var viewModel: RecipeTableViewModel

    /** Initializer to inject a view model with dependency injection
    - Parameter viewModel: The view model to be injected, defaults to a new instance of RecipeTableViewModel, though we can create alternative version of the API that can be used to further seperate testing.
    */
    init(viewModel: RecipeTableViewModel = RecipeTableViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    /**
     Create the main UI elements of the class.
     */
    var body: some View {
        NavigationView {
            // List displaying the recipes. Called from our recipeAPI.
            List(viewModel.recipes) { recipe in
                // Navigation link to DetailedRecipeView when a recipe is selected
                NavigationLink(destination: DetailedRecipeView(
                    selectedRecipeID: recipe.id,
                    selectedRecipeName: recipe.name
                )) {
                    //Creates the rows for the table, each rtow will contain the recipe's thumbnail followed by it's name. The image is give a place holder while we retrieve the image from the API call.
                    HStack {
                        //TODO: make it where we can stash the image thumbnails. Currently if you scroll too quickly we are hitting some networking issues. This is something I would like to learn more about. 
                        // Asynchronous image loading with placeholder
                        AsyncImage(url: URL(string: recipe.thumbnail)) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50) // Set image frame size
                        } placeholder: {
                            ProgressView() // Display progress view while loading
                        }
                        .clipShape(Circle()) // Clip image to a circular shape
                        .accessibilityIdentifier("\(recipe.name)-thumbnail") // Accessibility identifier for the image, used for UI navigation
                        
                        //Put the name of the recipe into the row after the image
                        Text(recipe.name.capitalized)
                    }
                }
                .accessibilityIdentifier(recipe.name.capitalized) // Accessibility identifier for the list item
            }
            .accessibilityIdentifier("recipeTableView") // Accessibility identifier for the table view
            .navigationTitle("Recipes") // Set the navigation bar title
            .task {
                await viewModel.fetchRecipes() // Fetch recipes when the view appears
            }
            .alert(item: $viewModel.error) { error in
                // Display an alert if an error occurs
                Alert(title: Text("Error"), message: Text(error.localizedDescription))
            }
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Ensure same behavior on iPad and
    }
        
        
        /**
         RecipeTableViewModel: This handles the API calls and propigates the recipes into our view model. It creates a RecipeStructer from the JSON data from the API socket: https://www.themealdb.com/api/json/v1/1/filter.php?c=Dessert.
         This structure is called the ShortHandResponse and contains an array of ShortHandMeal structurs. These ShortHandMeal structures contain the id, name, and thumbnail of each recipe. This information is then used to fill in the rows of the RecipeTableView.
         
         - Note: This method is async and throws
         - throws:
         - `NTError.invalidURL`: If the API URL is invalid.
         - `NTError.invalidResponse`: If the API response is not as expected.
         - `NTError.invalidData`: If the data received from the API is invalid.
         - `NTError.badRequest`: If the API request is malformed or incorrect.
         - `NTError.decodingError`: If there is an error decoding the JSON from the API.
         */
        class RecipeTableViewModel: ObservableObject {
            @Published var recipes: [ShortHandMeal] = [] // Published list of recipes
            @Published var error: NetworkError? // Published error state
            
            let recipeAPICaller: RecipeAPIProtocol // API caller for fetching recipes
            
            // Initializer with dependency injection for the API caller
            init(recipeAPICaller: RecipeAPIProtocol = RecipeAPI()) {
                self.recipeAPICaller = recipeAPICaller
            }
            
            // Asynchronous function to fetch recipes
            @MainActor
            func fetchRecipes() async {
                do {
                    // Fetch and decode recipes
                    let jsonData = try await recipeAPICaller.getRecipesList()
                    self.recipes = try recipeAPICaller.decodeRecipesList(recipeListData: jsonData)
                } catch let error as NetworkError {
                    // Handle known network errors
                    self.error = error
                    print("A network error occurred: \(error)")
                } catch {
                    // Handle unknown errors
                    let networkError = NetworkError.unknown(error)
                    self.error = networkError
                    print("An unknown error occurred: \(networkError)")
                }
            }
        }
    }
