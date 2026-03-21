//
//  RecipeExt.swift
//  RecipeStream
//
//  Created by Abanoob Samy on 21/03/2026.
//

import Foundation
import FirebaseAuth

extension Recipe {
    
    // MARK: - 1. Convert Object to Dictionary (For Saving to Firestore)
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [:]
        
        // We use `if let` to ensure that no null (nil) values ​​are sent to the database to save space.
        if let id = id { dict["id"] = id }
        if let name = name { dict["name"] = name }
        if let image = image { dict["image"] = image }
        if let rating = rating { dict["rating"] = rating }
        if let prepTimeMinutes = prepTimeMinutes { dict["prepTimeMinutes"] = prepTimeMinutes }
        if let cookTimeMinutes = cookTimeMinutes { dict["cookTimeMinutes"] = cookTimeMinutes }
        if let caloriesPerServing = caloriesPerServing { dict["caloriesPerServing"] = caloriesPerServing }
        if let difficulty = difficulty { dict["difficulty"] = difficulty }
        if let servings = servings { dict["servings"] = servings }
        if let tags = tags { dict["tags"] = tags }
        if let instructions = instructions { dict["instructions"] = instructions }
        if let ingredients = ingredients { dict["ingredients"] = ingredients }
        if let mealType = mealType { dict["mealType"] = mealType }
        if let cuisine = cuisine { dict["cuisine"] = cuisine }
        
        return dict
    }
    
    // MARK: - 2. Convert Dictionary to Object (For Reading from Firestore)
    init?(dictionary: [String: Any]) {
        // We consider the ID to be a basic requirement; if it is not present, we do not create the recipe.
        guard let id = dictionary["id"] as? Int else { return nil }
        
        self.init(
            id: id,
            name: dictionary["name"] as? String,
            ingredients: dictionary["ingredients"] as? [String],
            instructions: dictionary["instructions"] as? [String],
            prepTimeMinutes: dictionary["prepTimeMinutes"] as? Int,
            cookTimeMinutes: dictionary["cookTimeMinutes"] as? Int,
            servings: dictionary["servings"] as? Int,
            difficulty: dictionary["difficulty"] as? String,
            cuisine: dictionary["cuisine"] as? String,
            caloriesPerServing: dictionary["caloriesPerServing"] as? Int,
            tags: dictionary["tags"] as? [String],
            userID: dictionary["userId"] as? Int,
            image: dictionary["image"] as? String,
            rating: dictionary["rating"] as? Double,
            reviewCount: dictionary["reviewCount"] as? Int,
            mealType: dictionary["mealType"] as? [String]
        )
    }
}
