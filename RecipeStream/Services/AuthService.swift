//
//  AuthService.swift
//  RecipeStream
//
//  Created by Abanoob Samy on 18/03/2026.
//

import Foundation
import RxSwift
import FirebaseAuth
import FirebaseFirestore

class AuthService: AuthServiceProtocol {
        
    private let imageUploadService: ImageUploadServiceProtocol
        
    init(imageUploadService: ImageUploadServiceProtocol = ImageUploadService()) {
        self.imageUploadService = imageUploadService
    }
    
    func login(email: String, password: String) -> Completable {
        return Completable.create { completable in
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    completable(.error(error))
                    return
                }
                guard let uid = authResult?.user.uid else {
                    let unknownError = NSError(domain: "AuthError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unknown login error."])
                    completable(.error(unknownError))
                    return
                }
                _ = FirestoreManager.shared.getDocument(
                    collection: Constants.Firestore.Collections.users,
                    documentId: uid,
                    as: UserModel.self
                ).subscribe(onSuccess: { user in
                    DispatchQueue.main.async {

                        print("User name: \(user.name ?? "")")
                        SessionManager.currentUser = user
                        completable(.completed)
                    }
                }, onFailure: { error in
                    completable(.error(error))
                })
            }
            return Disposables.create()
        }
    }
    
    func signUp(username: String, name: String, email: String, password: String, profileImage: UIImage?) -> Completable {
        return Completable.create { completable in
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    completable(.error(error))
                    return
                }

                guard let uid = authResult?.user.uid else {
                    let unknownError = NSError(domain: "AuthError", code: 0,
                                               userInfo: [NSLocalizedDescriptionKey: "An unknown error occurred; we were unable to retrieve user data."])
                    completable(.error(unknownError))
                    return
                }
                                                
                if let image = profileImage {
                    _ = self.imageUploadService.uploadImage(image: image).subscribe(
                        onSuccess: { imageUrl in
                            print("Image uploaded with URL: \(imageUrl)")
                            self.saveUserToFirestore(uid: uid, username: username, name: name, email: email, profileUrl: imageUrl, completable: completable)
                        },
                        onFailure: { error in
                            // if image uploaded fail for any reason
                            completable(.error(error))
                        }
                    )
                } else {
                    self.saveUserToFirestore(uid: uid, username: username, name: name, email: email, profileUrl: "", completable: completable)
                }
            }
            return Disposables.create()
        }
    }
        
    private func saveUserToFirestore(uid: String, username: String, name: String, email: String, profileUrl: String, completable: @escaping (CompletableEvent) -> Void) {
            
        let newUser = UserModel(
            uid: uid,
            username: username,
            name: name,
            email: email,
            profileImageUrl: profileUrl,
            favorites: []
        ) // the server will understand the time createdAt by default adding to firestore
            
        _ = FirestoreManager.shared.setDocument(
            collection: Constants.Firestore.Collections.users,
            documentId: uid,
            data: newUser
        ).subscribe(
            onCompleted: {
                DispatchQueue.main.async {
                    SessionManager.currentUser = newUser
                    print("SessionManager:uid= \(SessionManager.currentUser?.uid ?? "nil")")
                    print("SessionManager:newUser= \(newUser.username ?? "")")
                    completable(.completed)
                }
            },
            onError: { error in
                completable(.error(error))
            }
        )
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

