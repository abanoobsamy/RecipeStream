//
//  RegisterVC.swift
//  RecipeStream
//
//  Created by Abanoob Samy on 18/03/2026.
//

import UIKit
import RxSwift
import RxCocoa
import PhotosUI

class RegisterVC: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPassField: UITextField!
    @IBOutlet weak var btnPolicy: UIButton!
    @IBOutlet weak var policyLbl: UITextView!
    
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var btnApple: UIButton!
    @IBOutlet weak var btnGoogle: UIButton!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnUpload: UIButton!
    
    @IBOutlet weak var userIV: UIImageView!
    private let spinner = UIActivityIndicatorView(style: .medium)
    
    // MARK: - Properties
    let viewModel = RegisterViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupToolbar()
        setupViews()
        setupBindings()
    }
    
    func setupToolbar() {
        self.title = "Sign Up"
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
                
        spinner.color = .white
        spinner.translatesAutoresizingMaskIntoConstraints = false
        btnRegister.addSubview(spinner)
        NSLayoutConstraint.activate([
            spinner.centerYAnchor.constraint(equalTo: btnRegister.centerYAnchor),
            spinner.centerXAnchor.constraint(equalTo: btnRegister.centerXAnchor)
        ])
        
        let darkColor = UIColor(red: 0.16, green: 0.22, blue: 0.29, alpha: 1.0)
        userIV.makeDashedCircle(color: darkColor, lineWidth: 2, dashPattern: [12, 10])
    }
    
    func setupBindings() {
        
        policyLbl.isUserInteractionEnabled = true
        let policyTapGesture = UITapGestureRecognizer()
        policyLbl.addGestureRecognizer(policyTapGesture)

        policyTapGesture.rx.event
            .bind(onNext: { [weak self] _ in
                print("Privacy Policy Tapped")
                let vc = PrivacyPolicyVC()
                self?.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)

        btnAdd.isUserInteractionEnabled = true
        btnUpload.isUserInteractionEnabled = true
        userIV.isUserInteractionEnabled = true
        
        let uploadTapGesture = UITapGestureRecognizer()
        btnAdd.addGestureRecognizer(uploadTapGesture)
        btnUpload.addGestureRecognizer(uploadTapGesture)
        userIV.addGestureRecognizer(uploadTapGesture)

        uploadTapGesture.rx.event
            .bind(onNext: { [weak self] _ in
                print("Upload Image Tapped")
                self?.openGallery()
            })
            .disposed(by: disposeBag)
        
        nameField.rx.text.orEmpty
            .bind(to: viewModel.nameText)
            .disposed(by: disposeBag)
        
        emailField.rx.text.orEmpty
            .bind(to: viewModel.emailText)
            .disposed(by: disposeBag)
        
        passwordField.rx.text.orEmpty
            .bind(to: viewModel.passwordText)
            .disposed(by: disposeBag)
        
        confirmPassField.rx.text.orEmpty
            .bind(to: viewModel.confirmPassText)
            .disposed(by: disposeBag)
                
        btnRegister.rx.tap
            .bind(to: viewModel.registerButtonTapped)
            .disposed(by: disposeBag)
        
        btnPolicy.rx.tap
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                btnPolicy.isSelected.toggle()
                let imageName = btnPolicy.isSelected ? "checkmark.square.fill" : "square"
                btnPolicy.setImage(UIImage(systemName: imageName), for: .normal)
                btnPolicy.tintColor = btnPolicy.isSelected ? .systemPink : .lightGray
                
                // If your viewModel exposes a PublishRelay<Bool> for isChecked:
                viewModel.isChecked.accept(btnPolicy.isSelected)
                // Otherwise adapt to your API as needed
                
                print("btnPolicyTapped \(btnPolicy.isSelected)")
            })
            .disposed(by: disposeBag)
        
        viewModel.isRegEnabled
            .subscribe(onNext: { [weak self] isEnabled in
                guard let self else { return }
                btnRegister.isEnabled = isEnabled
                btnRegister.alpha = isEnabled ? 1.0 : 0.5
            })
            .disposed(by: disposeBag)
        
        viewModel.isLoading
            .subscribe(onNext: { [weak self] isLoading in
                guard let self else { return }
                
                if isLoading {
                    btnRegister.setTitle("", for: .normal)
                    spinner.startAnimating()
                } else {
                    btnRegister.setTitle("Sign Up", for: .normal)
                    spinner.stopAnimating()
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.registerSuccess
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self else { return }
                navigateToHome()
            })
            .disposed(by: disposeBag)
        
        viewModel.errorMessage
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] message in
                guard let self else { return }
                showErrorAlert(message: message)
            })
            .disposed(by: disposeBag)
    }
    
    private func openGallery() {
        // 1. نجهز إعدادات المعرض
        var config = PHPickerConfiguration()
        config.selectionLimit = 1 // عايزين صورة واحدة بس للبروفايل
        config.filter = .images // يعرض صور بس (يخفي الفيديوهات)
        
        // 2. ننشئ الشاشة بتاعة المعرض
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self // عشان يرد علينا بالصورة اللي اليوزر اختارها
        
        // 3. نعرض الشاشة
        present(picker, animated: true)
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Oops!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func navigateToHome() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        
        let mainTabBar = HomeTabBarController()
        
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            window.rootViewController = mainTabBar
        }, completion: nil)
    }
    
    @IBAction func btnLoginTapped(_ sender: Any) {
        let vc = LoginVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

