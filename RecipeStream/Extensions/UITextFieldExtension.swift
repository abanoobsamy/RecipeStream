//
//  UITextFieldExtension.swift
//  RecipeStream
//
//  Created by Abanoob Samy on 17/03/2026.
//

import UIKit

extension UITextField {
    
    func applyPremiumStyle(placeholderText: String,
                           bgColor: UIColor = UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1.0),
                           cornerRadius: CGFloat = 12,
                           padding: CGFloat = 16,
                           hasBorder: Bool = false,          // 👈 الإضافة هنا
                           borderColor: UIColor = .darkGray, // لون البوردر الافتراضي
                           borderWidth: CGFloat = 1.0) {     // سمك البوردر الافتراضي
        
        // 1. تظبيط الشكل الخارجي
        self.backgroundColor = bgColor
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
        self.borderStyle = .none
        
        // 2. 🖼️ تظبيط البوردر (على حسب طلبك)
        if hasBorder {
            self.layer.borderWidth = borderWidth
            self.layer.borderColor = borderColor.cgColor
        } else {
            self.layer.borderWidth = 0 // مفيش بوردر
        }
        
        // 3. ألوان الكلام
        self.textColor = .white
        self.tintColor = .systemPink
        
        // 4. تظبيط لون الـ Placeholder
        self.attributedPlaceholder = NSAttributedString(
            string: placeholderText,
            attributes: [.foregroundColor: UIColor.gray]
        )
        
        // 5. البادينج
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: 50))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func enablePasswordToggle() {
        self.isSecureTextEntry = true
        
        // 1. نرجع للزرار الـ Custom العادي جداً (أضمن بكتير من الـ Configuration في تغيير الحالات)
        let eyeButton = UIButton(type: .custom)
        eyeButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)   // حالة الباسورد المخفي
        eyeButton.setImage(UIImage(systemName: "eye"), for: .selected)       // حالة الباسورد الظاهر
        eyeButton.tintColor = .lightGray
        
        // 2. حاوية الزرار (عشان نظبط مسافة الـ Padding من اليمين)
        let buttonContainer = UIView(frame: CGRect(x: 0, y: 0, width: 45, height: 40))
        eyeButton.frame = CGRect(x: 0, y: 0, width: 30, height: 40)
        buttonContainer.addSubview(eyeButton)
        
        self.rightView = buttonContainer
        self.rightViewMode = .always
        
        eyeButton.addTarget(self, action: #selector(togglePasswordView(_:)), for: .touchUpInside)
    }
    
    @objc private func togglePasswordView(_ sender: UIButton) {
        print("Eye Button Tapped! 👁️ sender.isSelected: \(sender.isSelected)")
        let currentText = self.text
        
        sender.isSelected.toggle()
        self.isSecureTextEntry = !sender.isSelected
        
        self.text = currentText
    }
}
