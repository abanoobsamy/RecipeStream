//
//  UserModel.swift
//  RecipeStream
//
//  Created by Abanoob Samy on 19/03/2026.
//


import Foundation
import FirebaseFirestore

struct UserModel: Codable, Sendable {
    let uid: String
    let name: String
    let email: String
    var favorites: [String]
    
    @ServerTimestamp var createdAt: Date?
    
}
