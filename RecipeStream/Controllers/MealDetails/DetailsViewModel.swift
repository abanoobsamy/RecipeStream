//
//  DetailsViewModel.swift
//  RecipeStream
//
//  Created by Abanoob Samy on 20/03/2026.
//

import Foundation
import RxSwift
import RxCocoa

// 'final' for (Static Dispatch)
final class DetailsViewModel {
    
    // MARK: - Outputs (Data Streams)
    let imageUrl = BehaviorRelay<URL?>(value: nil)
    let title = BehaviorRelay<String>(value: "")
    let author = BehaviorRelay<String>(value: "")
    
    let time = BehaviorRelay<String>(value: "")
    let calories = BehaviorRelay<String>(value: "")
    let level = BehaviorRelay<String>(value: "")
    let servings = BehaviorRelay<String>(value: "")
    
    let tags = BehaviorRelay<[String]>(value: [])
    let ingredients = BehaviorRelay<[IngredientItem]>(value: [])
    let instructions = BehaviorRelay<[String]>(value: [])
    
    // MARK: - Private Properties
    private let recipe: Recipe
    
    // MARK: - Init
    init(recipe: Recipe) {
        self.recipe = recipe
        setupData()
    }
    
    // MARK: - Data Formatting
    private func setupData() {
        if let urlString = recipe.image {
            imageUrl.accept(URL(string: urlString))
        }
        
        title.accept(recipe.name ?? "Unknown Recipe")
        author.accept("By \(recipe.rating ?? 0) Chef")
        
        time.accept("\(recipe.cookTimeMinutes ?? 0) min")
        calories.accept("\(recipe.caloriesPerServing ?? 0) kcal")
        level.accept(recipe.difficulty ?? "")
        
        servings.accept("\(recipe.servings ?? 0) servings")
        
        tags.accept(recipe.tags ?? [])
        instructions.accept(recipe.instructions ?? [])
        
        let mappedIngredients = (recipe.ingredients ?? []).map { ingredientString in
            return IngredientItem(title: ingredientString, isChecked: false)
        }
        ingredients.accept(mappedIngredients)
    }
    
    func toggleIngredient(at index: Int) {
        var currentItems = ingredients.value
        currentItems[index].isChecked.toggle()
        
        ingredients.accept(currentItems)
    }
}
