//
//  RecipeResponse.swift
//  RecipeStream
//
//  Created by Abanoob Samy on 20/03/2026.
//

import Foundation

// MARK: - RecipeResponse
struct RecipeResponse: Codable {
    let recipes: [Recipe]?
    let total, skip, limit: Int?
}

// MARK: - Recipe
struct Recipe: Codable {
    let id: Int?
    let name: String?
    let ingredients, instructions: [String]?
    let prepTimeMinutes, cookTimeMinutes, servings: Int?
    let difficulty: String?
    let cuisine: String?
    let caloriesPerServing: Int?
    let tags: [String]?
    let userID: Int?
    let image: String?
    let rating: Double?
    let reviewCount: Int?
    let mealType: [String]?

    enum CodingKeys: String, CodingKey {
        case id, name, ingredients, instructions, prepTimeMinutes, cookTimeMinutes, servings, difficulty, cuisine, caloriesPerServing, tags
        case userID = "userId"
        case image, rating, reviewCount, mealType
    }
}
