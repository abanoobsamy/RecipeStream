//
//  SessionManager.swift
//  RecipeStream
//
//  Created by Abanoob Samy on 19/03/2026.
//

import Foundation

struct SessionManager {
    
    // 1. حفظ الموديل بتاع اليوزر بالكامل
    @UserDefault(key: "cached_user", defaultValue: nil)
    static var currentUser: UserModel?
    
    // 2. (اختياري) حفظ هل اليوزر شاف شاشة الـ Onboarding ولا لأ
    @UserDefault(key: "has_seen_onboarding", defaultValue: false)
    static var hasSeenOnboarding: Bool
    
    @UserDefault(key: "uid", defaultValue: 0)
    static var uid: Int
    
    static var isLoggedIn: Bool {
        return currentUser != nil
    }
    
    // 3. دالة سريعة تمسح الداتا لما اليوزر يعمل Log Out
    static func clearSession() {
        currentUser = nil
        uid = 0
        hasSeenOnboarding = false
        // بنسيب الـ onboarding زي ما هي عشان ميشوفهاش تاني
    }
}
