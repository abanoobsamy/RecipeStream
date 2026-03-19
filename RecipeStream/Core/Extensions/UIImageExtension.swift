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
    
    func makeRoundIcon(bgColor: UIColor, iconColor: UIColor, bgOpacity: CGFloat = 0.15, radius: CGFloat = 12.0) {
        
        // 1. السر هنا: الشفافية بتتحط على لون الخلفية بس، مش على الـ View كله
        self.backgroundColor = bgColor.withAlphaComponent(bgOpacity)
        
        // 2. تلوين الأيقونة نفسها بلون صريح (100% وضوح)
        self.tintColor = iconColor
        
        // 3. المحافظة على حجم الأيقونة في النص (عشان متمطش وتملى المربع)
        self.contentMode = .center
        
        // 4. تدوير الحواف
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
        
        // 5. نتأكد إن الـ View نفسه مش شفاف عشان الأيقونة تفضل منورة
        self.alpha = 1.0
    }
    
    func makeRoundIcon(bgColor: UIColor, iconColor: UIColor, bgOpacity: CGFloat = 0.15, radius: CGFloat = 12.0, iconSize: CGFloat = 18.0) {
        
        // 1. تلوين الخلفية والـ UIImageView نفسها
        self.backgroundColor = bgColor.withAlphaComponent(bgOpacity)
        self.tintColor = iconColor
        
        // 2. تدوير الحواف
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
        
        // 3. السر هنا: منع الصورة إنها تتمط
        self.contentMode = .center
        
        // 4. التحكم في حجم الأيقونة (كل ما تصغر الـ iconSize، الفراغ/الـ padding هيزيد)
        let config = UIImage.SymbolConfiguration(pointSize: iconSize, weight: .medium)
        self.preferredSymbolConfiguration = config
    }
    
    /// تحويل الـ UIView لحاوية أيقونة مستديرة مع padding
    /// - Parameters:
    ///   - imageView: الـ UIImageView اللي هيكون جواه الأيقونة
    ///   - bgColor: لون الخلفية المستديرة
    ///   - iconColor: لون الأيقونة نفسها
    ///   - bgOpacity: شفافية لون الخلفية (مثلاً 0.15)
    ///   - radius: نصف قطر تدوير الحواف (Corner Radius)
    ///   - padding: المسافة بين حافة الأيقونة وحافة الحاوية
    func makeRoundIconContainer(imageView: UIImageView, bgColor: UIColor, iconColor: UIColor, bgOpacity: CGFloat = 0.15, radius: CGFloat = 12.0, padding: CGFloat = 10.0) {
        
        // 1. إعداد الـ View الحاوية (self)
        self.backgroundColor = bgColor.withAlphaComponent(bgOpacity)
        self.layer.cornerRadius = radius
        self.clipsToBounds = true // مهم لتدوير الحواف
        self.translatesAutoresizingMaskIntoConstraints = false
        
        // 2. إعداد الـ UIImageView
        self.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = iconColor // تلوين الأيقونة
        imageView.contentMode = .scaleAspectFit // المحافظة على تناسق الأيقونة
        
        // 3. ⚠️ تظبيط القيود (Constraints) عشان يكون فيه padding مظبوط
        NSLayoutConstraint.activate([
            // تثبيت الأيقونة في مركز الحاوية
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            // إضافة padding من كل الاتجاهات
            imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -padding)
        ])
    }
}
