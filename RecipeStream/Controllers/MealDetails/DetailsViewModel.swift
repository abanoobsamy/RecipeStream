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
    
    let isFavorite = BehaviorRelay<Bool>(value: false)
    let favoriteService: FavoriteServiceProtocol = FavoriteService.shared
    
    let tags = BehaviorRelay<[String]>(value: [])
    let ingredients = BehaviorRelay<[IngredientItem]>(value: [])
    let instructions = BehaviorRelay<[String]>(value: [])
    
    let mealType = BehaviorRelay<String>(value: "")
    
    let isLoading = BehaviorRelay<Bool>(value: false)
    let errorMessage = PublishRelay<String>()

    // MARK: - Private Properties
//    private let recipe: Recipe
    private var fetchedRecipeObject: Recipe?
    private let recipeId: Int
    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    init(recipeId: Int) {
        self.recipeId = recipeId
        fetchRecipeDetails()
        checkFavoriteStatus()
    }
    
    func fetchRecipeDetails() {
        isLoading.accept(true)
                
        let detailsRequest: RxSwift.Observable<Recipe> = NetworkManager.shared.request(RecipeRouter.getRecipeDetails(id: recipeId))
            .asObservable()
        
        let minDelay = RxSwift.Observable<Int>.timer(.seconds(3), scheduler: MainScheduler.instance)
        
        RxSwift.Observable.zip(detailsRequest, minDelay)
            .subscribe(onNext: { [weak self] (fetchedRecipe, _) in
                guard let self = self else { return }
                
                fetchedRecipeObject = fetchedRecipe
                setupData(with: fetchedRecipe)
                
            }, onError: { [weak self] error in
                guard let self = self else { return }
                isLoading.accept(false)
                errorMessage.accept(error.localizedDescription)
                
            }, onCompleted: { [weak self] in
                guard let self = self else { return }
                // zip show after 3 sec from getting data
                isLoading.accept(false)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Data Formatting
    private func setupData(with recipe: Recipe) {
        if let urlString = recipe.image {
            imageUrl.accept(URL(string: urlString))
        }
        
        title.accept(recipe.name ?? "Unknown Recipe")
        author.accept("By \(recipe.rating ?? 0) Chef")
        
        let prepTime = recipe.prepTimeMinutes ?? 0
        let cookTime = recipe.cookTimeMinutes ?? 0
        let totalTime = prepTime + cookTime
        
        time.accept("\(totalTime) min")
        calories.accept("\(recipe.caloriesPerServing ?? 0) kcal")
        level.accept(recipe.difficulty ?? "")
        
        servings.accept("\(recipe.servings ?? 0) servings")
        
        tags.accept(recipe.tags ?? [])
        instructions.accept(recipe.instructions ?? [])
        
        let mappedIngredients = (recipe.ingredients ?? []).map { ingredientString in
            return IngredientItem(title: ingredientString, isChecked: false)
        }
        ingredients.accept(mappedIngredients)
        
        let formattedMeals = (recipe.mealType ?? []).joined(separator: ", ")
        mealType.accept("\(formattedMeals)")
    }
    
    func toggleIngredient(at index: Int) {
        var currentItems = ingredients.value
        currentItems[index].isChecked.toggle()
        
        ingredients.accept(currentItems)
    }
    
    func favoriteButtonTapped() {
        guard let recipeToSave = self.fetchedRecipeObject else {
            errorMessage.accept("Recipe data is still loading, please wait.")
            return
        }
        
        let newState = !isFavorite.value
        isFavorite.accept(newState)
        
        favoriteService.toggleFavorite(recipe: recipeToSave, isFavorite: newState)
            .subscribe(onSuccess: {
                print("Successfully updated favorite in Firestore")
            }, onFailure: { [weak self] error in
                self?.isFavorite.accept(!newState)
                self?.errorMessage.accept(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    private func checkFavoriteStatus() {
        favoriteService.checkIsFavorite(recipeId: recipeId)
            .subscribe(onSuccess: { [weak self] isFav in
                // Update the Relay value, which will automatically update the heart color in VC
                self?.isFavorite.accept(isFav)
            }, onFailure: { error in
                print("Error checking favorite status: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
}
