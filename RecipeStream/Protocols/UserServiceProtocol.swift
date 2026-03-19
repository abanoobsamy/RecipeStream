//
//  UserServiceProtocol.swift
//  RecipeStream
//
//  Created by Abanoob Samy on 19/03/2026.
//

import RxSwift

protocol UserServiceProtocol {
    func getUserData(uid: String) -> Single<UserModel>
    func getCurrentUserData() -> Single<UserModel>
}
