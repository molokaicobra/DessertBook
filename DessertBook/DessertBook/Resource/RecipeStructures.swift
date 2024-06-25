//
//  RecipeStructures.swift
//  DessertBook
//
//  Created by Cobra Curtis on 6/20/24.
//

import Foundation

/**
 A struct representing a short version of a meal.
 - Parameters:
   - id: The meal ID.
   - name: The meal name.
   - thumbnail: The URL string for the meal thumbnail.
 */
struct ShortHandMeal: Codable, Identifiable {
    let id: String
    let name: String
    let thumbnail: String
    
    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case name = "strMeal"
        case thumbnail = "strMealThumb"
    }
}

/**
 A struct representing the response containing a list of short meals.
 - Parameters:
   - meals: An array of ShortHandMeal objects.
 */
struct ShortHandResponse: Codable {
    let meals: [ShortHandMeal]
}

/**
 A struct representing a detailed recipe.
 - Parameters:
   - idMeal: The meal ID.
   - strMeal: The meal name.
   - strDrinkAlternate: The alternate drink name.
   - strCategory: The category of the meal.
   - strArea: The area of the meal.
   - strInstructions: The instructions for preparing the meal.
   - strMealThumb: The URL string for the meal thumbnail.
   - strTags: The tags associated with the meal.
   - strYoutube: The YouTube URL string for the meal.
   - strSource: The source URL string for the meal.
   - strImageSource: The image source URL string for the meal.
   - strCreativeCommonsConfirmed: The Creative Commons confirmation status.
   - dateModified: The date when the meal was last modified.
   - ingredients: An array of ingredients.
   - measurements: An array of measurements.
 */
struct Recipe: Decodable, Equatable {
    let idMeal: String
    let strMeal: String
    let strDrinkAlternate: String?
    let strCategory: String
    let strArea: String
    let strInstructions: String
    let strMealThumb: String
    let strTags: String?
    let strYoutube: String?
    let strSource: String?
    let strImageSource: String?
    let strCreativeCommonsConfirmed: String?
    let dateModified: String?
    
    // Ingredients and measurements
    let ingredients: [String]
    let measurements: [String]
    
    // Custom keys for nested decoding
    enum CodingKeys: String, CodingKey {
        case idMeal, strMeal, strDrinkAlternate, strCategory, strArea, strInstructions, strMealThumb, strTags, strYoutube, strSource, strImageSource, strCreativeCommonsConfirmed, dateModified
        
        case strIngredient1, strIngredient2, strIngredient3, strIngredient4, strIngredient5, strIngredient6, strIngredient7, strIngredient8, strIngredient9, strIngredient10, strIngredient11, strIngredient12, strIngredient13, strIngredient14, strIngredient15, strIngredient16, strIngredient17, strIngredient18, strIngredient19, strIngredient20
        
        case strMeasure1, strMeasure2, strMeasure3, strMeasure4, strMeasure5, strMeasure6, strMeasure7, strMeasure8, strMeasure9, strMeasure10, strMeasure11, strMeasure12, strMeasure13, strMeasure14, strMeasure15, strMeasure16, strMeasure17, strMeasure18, strMeasure19, strMeasure20
    }
    
    // Custom decoding to handle ingredients and measurements
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        idMeal = try container.decode(String.self, forKey: .idMeal)
        strMeal = try container.decode(String.self, forKey: .strMeal)
        strDrinkAlternate = try container.decodeIfPresent(String.self, forKey: .strDrinkAlternate)
        strCategory = try container.decode(String.self, forKey: .strCategory)
        strArea = try container.decode(String.self, forKey: .strArea)
        strInstructions = try container.decode(String.self, forKey: .strInstructions)
        strMealThumb = try container.decode(String.self, forKey: .strMealThumb)
        strTags = try container.decodeIfPresent(String.self, forKey: .strTags)
        strYoutube = try container.decodeIfPresent(String.self, forKey: .strYoutube)
        strSource = try container.decodeIfPresent(String.self, forKey: .strSource)
        strImageSource = try container.decodeIfPresent(String.self, forKey: .strImageSource)
        strCreativeCommonsConfirmed = try container.decodeIfPresent(String.self, forKey: .strCreativeCommonsConfirmed)
        dateModified = try container.decodeIfPresent(String.self, forKey: .dateModified)
        
        // Decode ingredients and measurements
        var ingredients: [String] = []
        var measurements: [String] = []
        
        for i in 1...20 {
            if let ingredientKey = CodingKeys(stringValue: "strIngredient\(i)"),
               let ingredient = try container.decodeIfPresent(String.self, forKey: ingredientKey),
               !ingredient.trimmingCharacters(in: .whitespaces).isEmpty {
                ingredients.append(ingredient)
            }
            if let measureKey = CodingKeys(stringValue: "strMeasure\(i)"),
               let measurement = try container.decodeIfPresent(String.self, forKey: measureKey),
               !measurement.trimmingCharacters(in: .whitespaces).isEmpty {
                measurements.append(measurement)
            }
        }
        
        self.ingredients = ingredients
        self.measurements = measurements
    }
}

/**
 A struct representing the response containing a list of detailed recipes.
 - Parameters:
   - meals: An array of Recipe objects.
 */
struct RecipeResponse: Decodable {
    let meals: [Recipe]
}
