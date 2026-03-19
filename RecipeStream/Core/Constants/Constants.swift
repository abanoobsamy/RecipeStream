//
//  Constants.swift
//  RecipeStream
//
//  Created by Abanoob Samy on 18/03/2026.
//

import Foundation

enum Constants {
    
    // MARK: - Firebase Constants
    enum Firestore {
        
        enum Collections {
            static let users = "users"
            static let recipes = "recipes"
        }
        
        // (User Document Fields)
        enum UserFields {
            static let uid = "uid"
            static let email = "email"
            static let displayName = "displayName"
            static let favorites = "favorites" 
        }
    }
    
    // MARK: - UI Constants
    enum Cells {
        static let recipeCellIdentifier = "RecipeCell"
    }
    
    enum Images {
        static let defaultPlaceholder = "placeholder_image"
    }
}
