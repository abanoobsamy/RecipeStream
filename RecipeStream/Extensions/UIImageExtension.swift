//
//  UIImageExtension.swift
//  RecipeStream
//
//  Created by Abanoob Samy on 16/03/2026.
//

import UIKit

extension UIImageView {
    
    func makeCircularIcon(bgColor: UIColor, _ iconColor: UIColor? = nil) {
        self.backgroundColor = bgColor
        if let iconColor {
            self.tintColor = iconColor
        }
        self.contentMode = .center
        
        // 3. التدويرة السحرية
        // بنحطها جوه DispatchQueue عشان نضمن إن الستوري بورد خلص حساب مقاساتها الأول
        // وميحصلش أي لخبطة بسبب الـ Constraints
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.layer.cornerRadius = self.frame.height / 2
            self.clipsToBounds = true
        }
    }
}
