//
//  SearchViewModel.swift
//  RecipeStream
//
//  Created by Abanoob Samy on 21/03/2026.
//

import Foundation
import RxSwift
import RxCocoa

class SearchViewModel {
    
    let favoriteService: FavoriteServiceProtocol = FavoriteService.shared
    let favoriteIDs = BehaviorRelay<Set<Int>>(value: [])

    // MARK: - Source of Truth
    private let rawSearchResults = BehaviorRelay<[Recipe]>(value: [])
    
    // MARK: - Inputs (Events from UI)
    let searchText = BehaviorRelay<String>(value: "")
    let selectedCategory = BehaviorRelay<String>(value: "All")
    
    // MARK: - Outputs (Data to UI)
    let searchResults = BehaviorRelay<[Recipe]>(value: [])
    let categories = BehaviorRelay<[String]>(value: ["All", "Breakfast", "Dinner", "Italian", "Quick"])
    
    // "FOUND 24 RESULTS FOR 'PASTA'"
    let resultsCountText = BehaviorRelay<String>(value: "")
    
    let isLoading = BehaviorRelay<Bool>(value: false)
    let errorMessage = PublishRelay<String>()
    
    private let disposeBag = DisposeBag()
    
    init() {
        setupSearchLogic()
        setupCategoryFilteringLogic()
        fetchFavoriteIDs()
    }
    
    private func setupSearchLogic() {
        searchText
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance) // Wait half a second after the user stops typing
            .distinctUntilChanged() // Do not send a request if the text is the same as before.
            .subscribe(onNext: { [weak self] query in
                guard let self = self else { return }
                
                if query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    // If the search box is empty, we clear the results.
                    self.rawSearchResults.accept([])
                    self.resultsCountText.accept("Type to search recipes...")
                } else {
                    // if there text call API
                    self.fetchSearchResults(query: query)
                }
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - 2. Filtering Logic (Combine API Results + Selected Category)
    private func setupCategoryFilteringLogic() {
        RxSwift.Observable.combineLatest(
            rawSearchResults,
            selectedCategory,
            searchText
        )
        .map { recipes, category, query -> ([Recipe], String) in
            // Filter results based on the selected classification
            let filteredRecipes: [Recipe]
            
            if category == "All" {
                filteredRecipes = recipes
            } else {
                // We search for mealType, tags, or cuisine (based on what the API provides)
                filteredRecipes = recipes.filter { recipe in
                    let inMealType = recipe.mealType?.contains(category) ?? false
                    let inTags = recipe.tags?.contains(category) ?? false
                    let inCuisine = recipe.cuisine == category
                    return inMealType || inTags || inCuisine
                }
            }
            
            // (For Example: FOUND 4 RESULTS FOR "PASTA")
            let textQuery = query.isEmpty ? "" : " FOR \"\(query.uppercased())\""
            let resultString = "FOUND \(filteredRecipes.count) RESULTS\(textQuery)"
            
            return (filteredRecipes, resultString)
        }
        .subscribe(onNext: { [weak self] (finalRecipes, finalString) in
            // Send to UI
            self?.searchResults.accept(finalRecipes)
            self?.resultsCountText.accept(finalString)
        })
        .disposed(by: disposeBag)
    }
    
    // MARK: - API Calls
    private func fetchSearchResults(query: String) {
        isLoading.accept(true)
        
        // /recipes/search?q=query)
        let parameters = ["q": query]
        let searchRequest: RxSwift.Observable<RecipeResponse> = NetworkManager.shared.request(RecipeRouter.searchRecipes(parameters: parameters)).asObservable()
        
        searchRequest.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] response in
                self?.isLoading.accept(false)
                if let recipes = response.recipes {
                    self?.rawSearchResults.accept(recipes)
                }
            }, onError: { [weak self] error in
                self?.isLoading.accept(false)
                self?.errorMessage.accept(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func toggleFavorite(recipe: Recipe) {
        guard let recipeID = recipe.id else { return }
        
        // Knowing the new state (opposite of the current state)
        var currentFavs = favoriteIDs.value
        let isCurrentlyFavorite = currentFavs.contains(recipeID)
        let newState = !isCurrentlyFavorite
        
        // Real-time local update (Optimistic UI) so that the heart color changes instantly without delay
        if newState {
            currentFavs.insert(recipeID)
        } else {
            currentFavs.remove(recipeID)
        }
        favoriteIDs.accept(currentFavs)
        
        favoriteService.toggleFavorite(recipe: recipe, isFavorite: newState)
            .subscribe(onSuccess: {
                let action = newState ? "added to" : "removed from"
                print("Recipe \(recipe.name ?? "") \(action) favorites!")
            }, onFailure: { [weak self] error in
                self?.errorMessage.accept(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func fetchFavoriteIDs() {
        favoriteService.getFavoriteIDs()
            .subscribe(onSuccess: { [weak self] ids in
                self?.favoriteIDs.accept(ids)
            }, onFailure: { error in
                print("Failed to fetch favorite IDs: \(error)")
            })
            .disposed(by: disposeBag)
    }
}
