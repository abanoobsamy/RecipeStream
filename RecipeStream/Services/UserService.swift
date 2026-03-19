//
//  UserService.swift
//  RecipeStream
//
//  Created by Abanoob Samy on 19/03/2026.
//

import Foundation
import RxSwift
import FirebaseAuth

class UserService: UserServiceProtocol {

    func getUserData(uid: String) -> Single<UserModel> {
        return FirestoreManager.shared.getDocument(
            collection: Constants.Firestore.Collections.users,
            documentId: uid,
            as: UserModel.self
        )
    }
    
    func getCurrentUserData() -> Single<UserModel> {
        guard let currentUid = Auth.auth().currentUser?.uid else {
            let error = NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "No user logged in"])
            return .error(error)
        }
        
        return getUserData(uid: currentUid)
    }
}
