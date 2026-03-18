//
//  RegisterVC.swift
//  RecipeStream
//
//  Created by Abanoob Samy on 18/03/2026.
//

import UIKit

class RegisterVC: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPassField: UITextField!
    @IBOutlet weak var btnPolicy: UIButton!
    @IBOutlet weak var policyLbl: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupToolbar()
        setupViews()
    }
    
    func setupViews() {
        nameField.applyPremiumStyle(placeholderText: "John Doe", bgColor: .colorBGDark)
        emailField.applyPremiumStyle(placeholderText: "name@example.com", bgColor: .colorBGDark)
        passwordField.applyPremiumStyle(placeholderText: "Create a password", bgColor: .colorBGDark)
        confirmPassField.applyPremiumStyle(placeholderText: "Repeat password", bgColor: .colorBGDark)
        
        nameField.addLeftIcon(UIImage(systemName: "person"))
        emailField.addLeftIcon(UIImage(systemName: "envelope"))
        passwordField.addLeftIcon(UIImage(systemName: "lock"))
        confirmPassField.addLeftIcon(UIImage(systemName: "shield.checkered"))
        
        passwordField.enablePasswordToggle()
        confirmPassField.enablePasswordToggle()
        
        btnPolicy.setImage(UIImage(systemName: "square"), for: .normal)
        btnPolicy.tintColor = .lightGray
    }
    
    func setupToolbar() {
        self.title = "Sign Up"
    }
    
    @IBAction func btnPolicyTapped(_ sender: Any) {
        print("bob")
        
        if let button = sender as? UIButton {
            button.isSelected = !button.isSelected
            let imageName = button.isSelected ? "checkmark.square.fill" : "square"
            button.setImage(UIImage(systemName: imageName), for: .normal)
            
            button.tintColor = button.isSelected ? .systemPink : .lightGray
            
            print("Checkbox State is now: \(button.isSelected)")
        }
    }
    
    @IBAction func BtnRegisterTapped(_ sender: Any) {
        print("policy selected: \(btnPolicy.isSelected)")
    }
    
    @IBAction func btnAppleTapped(_ sender: Any) {
    }
    
    @IBAction func btnGoogleTapped(_ sender: Any) {
    }
    
    @IBAction func btnLoginTapped(_ sender: Any) {
        let vc = LoginVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
