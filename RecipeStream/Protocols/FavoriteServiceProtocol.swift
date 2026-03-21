//
//  FavoriteServiceProtocol.swift
//  RecipeStream
//
//  Created by Abanoob Samy on 21/03/2026.
//

import RxSwift

protocol FavoriteServiceProtocol {
    func toggleFavorite(recipe: Recipe, isFavorite: Bool) -> Single<Void>
    func getFavorites() -> Single<[Recipe]>
    func checkIsFavorite(recipeId: Int) -> Single<Bool>
    func getFavoriteIDs() -> Single<Set<Int>>
}
