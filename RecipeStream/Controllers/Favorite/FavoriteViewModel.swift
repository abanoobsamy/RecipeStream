//
//  FavoriteViewModel.swift
//  RecipeStream
//
//  Created by Abanoob Samy on 21/03/2026.
//

import Foundation
import RxSwift
import RxCocoa

class FavoriteViewModel {
    
    // MARK: - Outputs
    let favorites = BehaviorRelay<[Recipe]>(value: [])
    let isLoading = BehaviorRelay<Bool>(value: false)
    
    var isEmpty: RxSwift.Observable<Bool> {
        return favorites.asObservable()
            .map { $0.isEmpty }
            .distinctUntilChanged()
    }
    
    private let favoriteService: FavoriteServiceProtocol = FavoriteService.shared
    private let disposeBag = DisposeBag()
    
    init() {
        fetchFavorites()
    }
    
    func fetchFavorites() {
        isLoading.accept(true)
        favoriteService.getFavorites()
            .subscribe(onSuccess: { [weak self] recipes in
                self?.isLoading.accept(false)
                self?.favorites.accept(recipes)
            }, onFailure: { [weak self] error in
                self?.isLoading.accept(false)
                print("Error: \(error)")
            })
            .disposed(by: disposeBag)
    }
    
    func deleteFavorite(at index: Int) {
        var current = favorites.value
        guard index < current.count else { return }
        
        let recipeToRemove = current[index]
        
        // Fast local update (Optimistic UI)
        current.remove(at: index)
        favorites.accept(current)
        
        // Update in Firestore
        favoriteService.toggleFavorite(recipe: recipeToRemove, isFavorite: false)
            .subscribe(onSuccess: {
                print("Removed from Firestore successfully")
            }, onFailure: { [weak self] error in
                self?.fetchFavorites()
            })
        .disposed(by: disposeBag)
    }
}
