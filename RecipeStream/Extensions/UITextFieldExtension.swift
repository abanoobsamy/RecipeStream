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
        
        self.backgroundColor = bgColor
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
        self.borderStyle = .none
        
        if hasBorder {
            self.layer.borderWidth = borderWidth
            self.layer.borderColor = borderColor.cgColor
        } else {
            self.layer.borderWidth = 0
        }
        
        self.textColor = .white
        self.tintColor = .systemPink
        
        // placeholder color
        self.attributedPlaceholder = NSAttributedString(
            string: placeholderText,
            attributes: [.foregroundColor: UIColor.gray]
        )
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: 50))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func enablePasswordToggle() {
        self.isSecureTextEntry = true
        
        self.autocorrectionType = .no
        self.spellCheckingType = .no
        
        self.textAlignment = .left
        self.semanticContentAttribute = .forceLeftToRight
        
        let eyeButton = UIButton(type: .custom)
        eyeButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        eyeButton.tintColor = .lightGray
        
        let buttonContainer = UIView(frame: CGRect(x: 0, y: 0, width: 45, height: 40))
        eyeButton.frame = CGRect(x: 0, y: 0, width: 30, height: 40)
        buttonContainer.addSubview(eyeButton)
        
        self.rightView = buttonContainer
        self.rightViewMode = .always
        
        eyeButton.addTarget(self, action: #selector(togglePasswordView(_:)), for: .touchUpInside)
    }
    
    @objc private func togglePasswordView(_ sender: UIButton) {
        
        print("Eye Button Tapped! 👁️ self.isSecureTextEntry: \(self.isSecureTextEntry)")
        let currentText = self.text ?? ""
        
        self.isSecureTextEntry.toggle()
        
        self.font = nil
        self.font = UIFont.systemFont(ofSize: 14)
        
        let imageName = self.isSecureTextEntry ? "eye.slash" : "eye"
        sender.setImage(UIImage(systemName: imageName), for: .normal)
        
        if self.isSecureTextEntry { // if pass is hidden
            self.text = ""
            self.insertText(currentText)
        } else {
            self.text = currentText
        }
    }
}
