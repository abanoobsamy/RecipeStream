//
//  AppUser.swift
//  RecipeStream
//
//  Created by Abanoob Samy on 18/03/2026.
//


import Foundation

struct AppUser {
    let uid: String
    let email: String
    let displayName: String
    
    var dictionary: [String: Any] {
        return [
            Constants.Firestore.UserFields.uid: uid,
            Constants.Firestore.UserFields.email: email,
            Constants.Firestore.UserFields.displayName: displayName
        ]
    }
    
    init(id: String, dictionary: [String: Any]) {
        self.uid = id
        self.email = dictionary[Constants.Firestore.UserFields.email] as? String ?? ""
        self.displayName = dictionary[Constants.Firestore.UserFields.displayName] as? String ?? ""
    }
}
