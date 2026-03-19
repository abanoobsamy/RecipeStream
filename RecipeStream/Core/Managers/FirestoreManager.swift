//
//  FirebaseManager.swift
//  RecipeStream
//
//  Created by Abanoob Samy on 19/03/2026.
//

import Foundation
import RxSwift
import FirebaseFirestore

class FirestoreManager {
    
    static let shared = FirestoreManager()
    private let db = Firestore.firestore()
    
    private init() {}
    
    // 🌟 السحر هنا: حرف الـ T ده معناه "أي موديل بيعمل Decodable"
    func getDocument<T: Decodable>(collection: String, documentId: String, as type: T.Type) -> Single<T> {
        return Single.create { single in
            
            // استخدمنا Task عشان نتفادى إيرورات Swift 6 بتاعة الـ MainActor
            let task = Task {
                do {
                    let document = try await self.db.collection(collection).document(documentId).getDocument()
                    
                    // 1. نتأكد إن الملف موجود أصلاً
                    guard document.exists else {
                        let notFoundError = NSError(domain: "Firestore", code: 404, userInfo: [NSLocalizedDescriptionKey: "البيانات غير موجودة"])
                        single(.failure(notFoundError))
                        return
                    }
                    
                    // 2. الفك السحري للنوع اللي إنت باعته (T)
                    let decodedData = try document.data(as: T.self)
                    
                    // 3. نرجع الداتا بنجاح
                    single(.success(decodedData))
                    
                } catch {
                    // لو حصل إيرور في النت أو في فك التشفير
                    single(.failure(error))
                }
            }
            
            // عشان لو اليوزر قفل الشاشة والنت بيحمل، نلغي الـ Task ومناكلش الرامات
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    // 2. 🌟 الدالة الماستر للـ Set (للحفظ) 🌟
    func setDocument<T: Encodable>(collection: String, documentId: String, data: T) -> Completable {
        return Completable.create { completable in
            
            do {
                // بنستخدم setData(from:) اللي بتحول الـ Struct لـ فايربيس أوتوماتيك
                try self.db.collection(collection)
                    .document(documentId)
                    .setData(from: data) { error in
                        if let error = error {
                            completable(.error(error))
                        } else {
                            // مبروك، الداتا اتحفظت بنجاح!
                            completable(.completed)
                        }
                    }
            } catch {
                // لو حصل مشكلة في تحويل الموديل
                completable(.error(error))
            }
            
            return Disposables.create()
        }
    }
    
    func isUsernameAvailable(username: String) -> Single<Bool> {
        return Single.create { single in
            let safeUsername = username.lowercased().trimmingCharacters(in: .whitespaces)
            
            guard !safeUsername.isEmpty else {
                single(.success(false))
                return Disposables.create()
            }
            
            let task = Task {
                do {
                    let snapshot = try await self.db.collection(Constants.Firestore.Collections.users)
                        .whereField("username", isEqualTo: safeUsername)
                        .getDocuments()
                    
                    single(.success(snapshot.isEmpty))
                    
                } catch {
                    single(.failure(error))
                }
            }
            
            return Disposables.create { task.cancel() }
        }
    }
}
