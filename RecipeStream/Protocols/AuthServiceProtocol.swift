//
//  AuthService.swift
//  RecipeStream
//
//  Created by Abanoob Samy on 18/03/2026.
//

import RxSwift

protocol AuthServiceProtocol {
    func login(email: String, password: String) -> Completable
    func signUp(name: String, email: String, password: String) -> Completable
    func signOut() -> Completable
    func resetPassword(email: String) -> Completable
    func getCurrentUserId() -> String?
}
