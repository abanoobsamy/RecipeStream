//
//  UserDefault.swift
//  RecipeStream
//
//  Created by Abanoob Samy on 19/03/2026.
//

import Foundation

@propertyWrapper
struct UserDefault<T: Codable> {
    let key: String
    let defaultValue: T

    var wrappedValue: T {
        get {
            // بنحاول نقرأ الداتا من اللوكال
            guard let data = UserDefaults.standard.object(forKey: key) as? Data else {
                return defaultValue
            }
            // بنفك التشفير ونرجع الموديل بتاعنا
            let value = try? JSONDecoder().decode(T.self, from: data)
            return value ?? defaultValue
        }
        set {
            // بنشفر الموديل ونحفظه
            let data = try? JSONEncoder().encode(newValue)
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}
