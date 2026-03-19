//
//  Date+Ext.swift
//  RecipeStream
//
//  Created by Abanoob Samy on 19/03/2026.
//

import Foundation

extension Date {
    var greeting: String {
        let hour = Calendar.current.component(.hour, from: self)
        
        switch hour {
        case 5..<12: return "Good Morning" // From 5 AM to 11:59 AM
        case 12..<17: return "Good Afternoon" // From 12 PM to 4:59 PM
        case 17..<21: return "Good Evening" // From 5 PM to 8:59 PM
        default: return "Good Night" // From 9 PM to 4:59 AM
        }
    }
}
