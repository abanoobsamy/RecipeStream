//
//  HomeViewModel.swift
//  RecipeStream
//
//  Created by Abanoob Samy on 20/03/2026.
//

import Foundation
import RxSwift
import RxCocoa

class SeeAllViewModel {
    
    let favoriteService: FavoriteServiceProtocol = FavoriteService.shared
    let favoriteIDs = BehaviorRelay<Set<Int>>(value: [])

    // MARK: - Source of Truth - Outputs (Data going to UI)
    let allRecipes = BehaviorRelay<[Recipe]>(value: [])
    
    // MARK: - Inputs (Events come from UI)
    let pullToRefresh = PublishRelay<Void>()
        
    let isLoading = BehaviorRelay<Bool>(value: false)
    let errorMessage = PublishRelay<String>()
            
    private let disposeBag = DisposeBag()
    
    init() {
        fetchAllData()
        fetchFavoriteIDs()
        bindInputs()
    }
    
    private func bindInputs() {
        pullToRefresh
            .subscribe(onNext: { [weak self] in
                self?.fetchAllData()
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - API Calls
    func fetchAllData() {
        isLoading.accept(true)
                
        let allRecipeRequest: RxSwift.Observable<RecipeResponse> = NetworkManager.shared.request(RecipeRouter.getAllRecipes(parameters: ["limit": 30]))
            .asObservable()
        
        let minDelay = RxSwift.Observable<Int>.timer(.seconds(3), scheduler: MainScheduler.instance)
        
        RxSwift.Observable.zip(allRecipeRequest, minDelay)
            .subscribe(onNext: { [weak self] (allRecipeResponse, _ ) in
                guard let self = self else { return }
                                
                if let allRecipe = allRecipeResponse.recipes {
                    self.allRecipes.accept(allRecipe)
                }
                
            }, onError: { [weak self] error in
                self?.isLoading.accept(false)
                self?.errorMessage.accept(error.localizedDescription)
                
            }, onCompleted: { [weak self] in
                // zip show after 3 sec from getting data
                self?.isLoading.accept(false)
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
