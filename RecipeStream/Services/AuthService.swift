//
//  AuthService.swift
//  RecipeStream
//
//  Created by Abanoob Samy on 18/03/2026.
//
import Foundation
import RxSwift
import FirebaseAuth

class AuthService: AuthServiceProtocol {
    
    func login(email: String, password: String) -> Completable {
        return Completable.create { completable in
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    completable(.error(error))
                } else  {
                    completable(.completed)
                }
            }
            return Disposables.create()
        }
    }
    
    func signUp(email: String, password: String) -> Completable {
        return Completable.create { completable in
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    completable(.error(error))
                } else  {
                    completable(.completed)
                }
            }
            return Disposables.create()
        }
    }
    
    func signOut() -> Completable {
        return Completable.create { completable in
            do {
                try Auth.auth().signOut()
                completable(.completed)
            } catch let signOutError as NSError {
                print("Error signing out: %@", signOutError)
                completable(.error(signOutError))
            }
            return Disposables.create()
        }
    }
    
    func resetPassword(email: String) -> Completable {
        return Completable.create { completable in
            Auth.auth().sendPasswordReset(withEmail: email) { error in
                if let error = error {
                    completable(.error(error))
                } else  {
                    completable(.completed)
                }
            }
            return Disposables.create()
        }
    }
    
    func getCurrentUserId() -> String? {
        return Auth.auth().currentUser?.uid
    }
    
    
}
