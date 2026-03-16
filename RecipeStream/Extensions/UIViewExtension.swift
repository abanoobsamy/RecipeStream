//
//  UIViewExtension.swift
//  RecipeStream
//
//  Created by Abanoob Samy on 16/03/2026.
//

import Foundation
import UIKit

extension UIView {
    
    func round(_ radius: CGFloat = 8) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
    /* [.layerMinXMinYCorner, .layerMaxXMinYCorner] for top
     * [.layerMinXMaxYCorner, .layerMaxXMaxYCorner] for bottom
     */
    func roundSpecificCorner(_ radius: CGFloat = 8, _ corners: CACornerMask) {
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = corners
        self.clipsToBounds = true
    }
    
    func circle() {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.layer.masksToBounds = true
    }
    
    func addBorder(color: UIColor, width: CGFloat) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
    
    func addCircularShadow(color: UIColor = .black, opacity: Float = 0.6, radius: CGFloat = 8, offset: CGSize = CGSize(width: 0, height: 3)) {
        
        // 1. تحديد لون الظل (يفضل استخدام UIColor)
        self.layer.shadowColor = color.cgColor
        
        // 2. تحديد شفافية الظل (من 0.0 إلى 1.0)
        self.layer.shadowOpacity = opacity
        
        // 3. تحديد نصف قطر التنعيم (Blur) للظل
        self.layer.shadowRadius = radius
        
        // 4. تحديد إزاحة الظل (Shadow Offset) لجعله يبدو ساقطاً لأسفل أو لليمين
        self.layer.shadowOffset = offset
        
        // 5. تأكد من أن الحواف غير مقصوصة ليظهر الظل بوضوح
        // ملاحظة: تأكد أيضاً من أن cornerRadius مضبوط على نصف الارتفاع/العرض لجعل الـ View دائرياً
        self.layer.masksToBounds = false
    }
}
