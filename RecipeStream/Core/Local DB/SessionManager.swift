//
//  SessionManager.swift
//  RecipeStream
//
//  Created by Abanoob Samy on 19/03/2026.
//

import Foundation
import FirebaseAuth

struct SessionManager {
    
    // 1. حفظ الموديل بتاع اليوزر بالكامل
    @UserDefault(key: "cached_user", defaultValue: nil)
    static var currentUser: UserModel?
    
    // 2. (اختياري) حفظ هل اليوزر شاف شاشة الـ Onboarding ولا لأ
    @UserDefault(key: "has_seen_onboarding", defaultValue: false)
    static var hasSeenOnboarding: Bool
    
    @UserDefault(key: "uid", defaultValue: "")
    static var uid: String
    
    static var isLoggedIn: Bool {
        return currentUser != nil
    }
    
    // Log Out
    static func clearSession() {
        do {
            try Auth.auth().signOut()
            // Clear cached session state only after successful sign out
            currentUser = nil
            uid = ""
            // If you want to force showing onboarding again, set to false; otherwise, keep the stored value.
            // hasSeenOnboarding = false
        } catch {
            // Handle sign out error (e.g., show an alert, log, etc.)
            print("Failed to sign out: \(error)")
        }
    }
}
