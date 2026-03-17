//
//  LoginVC.swift
//  RecipeStream
//
//  Created by Abanoob Samy on 15/03/2026.
//

import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet var parentView: UIView!
    @IBOutlet weak var containerFieldsView: UIView!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var logoIv: UIImageView!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var btnGoogle: UIButton!
    @IBOutlet weak var btnApple: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        parentView.setupGradient(colors: [
            UIColor.clear,
            UIColor.black.withAlphaComponent(0.8)
        ])
        
        containerFieldsView.addBorder(color: .colorGrayBlue, width: 0.5)
        containerFieldsView.round(24)
        logoIv.round(24)
    }
    
    func setupViews() {
        emailField.applyPremiumStyle(placeholderText: "name@example.com",
                                     bgColor: .colorBGDark,
                                     hasBorder: true)
        passwordField.applyPremiumStyle(placeholderText: "Enter password",
                                        bgColor: .colorBGDark,
                                        hasBorder: true,
                                        borderWidth: 1.5)
        
        passwordField.enablePasswordToggle()
    }
        
    @IBAction func btnForgetTapped(_ sender: Any) {
    }
    
    @IBAction func btnLoginTapped(_ sender: Any) {
    }
    
    @IBAction func btnAppleTapped(_ sender: Any) {
    }
    
    @IBAction func btnGoogleTapped(_ sender: Any) {
    }
    
    @IBAction func btnSignupTapped(_ sender: Any) {
    }
}
