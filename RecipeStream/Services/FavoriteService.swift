//
//  FavoriteService.swift
//  RecipeStream
//
//  Created by Abanoob Samy on 21/03/2026.
//

import FirebaseAuth
import FirebaseFirestore
import RxSwift
import RxCocoa

class FavoriteService: FavoriteServiceProtocol {
    
    static let shared = FavoriteService() // Singleton for easy access
    private let db = Firestore.firestore()
    
    private var currentUserID: String? {
        return Auth.auth().currentUser?.uid
    }
    
    // MARK: - Toggle Favorite (Add / Remove)
    func toggleFavorite(recipe: Recipe, isFavorite: Bool) -> Single<Void> {
        return Single.create { single in
            guard let uid = self.currentUserID else {
                single(.failure(NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not logged in"])))
                return Disposables.create()
            }
            
            let userRef = self.db.collection(Constants.Firestore.Collections.users).document(uid)
            
            var recipeData = recipe.toDictionary()
            recipeData["userId"] = uid
            
            let updateValue = isFavorite ? FieldValue.arrayUnion([recipeData]) : FieldValue.arrayRemove([recipeData])
            
            userRef.updateData([Constants.Firestore.Collections.favorites: updateValue]) { error in
                if let error = error {
                    single(.failure(error))
                } else {
                    single(.success(()))
                }
            }
            
            return Disposables.create()
        }
    }
    
    // MARK: - Get All Favorites
    func getFavorites() -> Single<[Recipe]> {
        return Single.create { single in
            guard let uid = self.currentUserID else {
                single(.failure(NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not logged in"])))
                return Disposables.create()
            }
            
            self.db.collection(Constants.Firestore.Collections.users)
                .document(uid)
                .getDocument { document, error in
                    if let error = error {
                        single(.failure(error))
                        return
                    }
                    
                    guard let data = document?.data(),
                          let favoritesArray = data[Constants.Firestore.Collections.favorites] as? [[String: Any]] else {
                        single(.success([])) // No favorites yet
                        return
                    }
                    
                    let recipes = favoritesArray.compactMap { Recipe(dictionary: $0) }
                    single(.success(recipes))
                }
            
            return Disposables.create()
        }
    }
    
    // MARK: - Check if Recipe is Favorite
    func checkIsFavorite(recipeId: Int) -> Single<Bool> {
        return Single.create { single in
            guard let uid = self.currentUserID else {
                single(.success(false))
                return Disposables.create()
            }
            
            self.db.collection(Constants.Firestore.Collections.users)
                .document(uid)
                .getDocument { document, error in
                    if let error = error {
                        single(.failure(error))
                        return
                    }
                    
                    guard let data = document?.data(),
                          let favoritesArray = data[Constants.Firestore.Collections.favorites] as? [[String: Any]] else {
                        single(.success(false))
                        return
                    }
                    
                    // Search within the array for the matching ID
                    let isFav = favoritesArray.contains { dict in
                        // We check the ID to see if it's recorded as an Int or a String
                        if let id = dict["id"] as? Int {
                            return id == recipeId
                        } else if let idString = dict["id"] as? String {
                            return idString == String(recipeId)
                        }
                        return false
                    }
                    
                    single(.success(isFav))
                }
            
            return Disposables.create()
        }
    }
    
    // MARK: - Get Only Favorite IDs (For fast checking in Lists)
    func getFavoriteIDs() -> Single<Set<Int>> {
        return Single.create { single in
            guard let uid = self.currentUserID else {
                single(.success([]))
                return Disposables.create()
            }
            
            self.db.collection(Constants.Firestore.Collections.users).document(uid).getDocument { document, error in
                if let error = error {
                    single(.failure(error))
                    return
                }
                
                guard let data = document?.data(),
                      let favoritesArray = data[Constants.Firestore.Collections.favorites] as? [[String: Any]] else {
                    single(.success([]))
                    return
                }
                
                // Extracting IDs only and converting them to a Set for faster searching
                let idsArray = favoritesArray.compactMap { dict -> Int? in
                    if let id = dict["id"] as? Int { return id }
                    if let idString = dict["id"] as? String { return Int(idString) }
                    return nil
                }
                
                single(.success(Set(idsArray)))
            }
            return Disposables.create()
        }
    }
}
