//
//  AuthService.swift
//  RecipeStream
//
//  Created by Abanoob Samy on 18/03/2026.
//

import RxSwift
import UIKit

protocol AuthServiceProtocol {
    func login(email: String, password: String) -> Completable
    func signUp(username: String, name: String, email: String, password: String, profileImage: UIImage?) -> Completable
    func signOut() -> Completable
    func resetPassword(email: String) -> Completable
    func getCurrentUserId() -> String?
}
