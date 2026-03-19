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
            // 1. بنجيب الداتا
            guard let data = UserDefaults.standard.data(forKey: key) else {
                return defaultValue
            }
            
            // 2. بنحاول نفك التشفير
            // استخدمنا JSONDecoder بشكل صريح
            let decoder = JSONDecoder()
            if let value = try? decoder.decode(T.self, from: data) {
                return value
            }
            
            return defaultValue
        }
        set {
            // 3. لو القيمة اللي جاية nil، بنمسح المفتاح خالص من الـ UserDefaults
            // ده مهم جداً عشان الـ Sign out يشتغل صح
            if let optional = newValue as? AnyOptional, optional.isNil {
                UserDefaults.standard.removeObject(forKey: key)
            } else {
                let encoder = JSONEncoder()
                if let data = try? encoder.encode(newValue) {
                    UserDefaults.standard.set(data, forKey: key)
                }
            }
        }
    }
}

// 🌟 حركة صياعة عشان الـ Wrapper يفهم الـ nil 🌟
protocol AnyOptional {
    var isNil: Bool { get }
}

extension Optional: AnyOptional {
    var isNil: Bool { self == nil }
}
