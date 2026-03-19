//
//  LoginVC.swift
//  RecipeStream
//
//  Created by Abanoob Samy on 15/03/2026.
//

import UIKit
import RxSwift
import RxCocoa

class LoginVC: UIViewController {
    
    // outlets
    @IBOutlet var parentView: UIView!
    @IBOutlet weak var containerFieldsView: UIView!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var logoIv: UIImageView!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var btnGoogle: UIButton!
    @IBOutlet weak var btnApple: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    
    private let spinner = UIActivityIndicatorView(style: .medium)
    
    // MARK: - Properties
    private let viewModel = LoginViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        
        setupViews()
        setupBindings()
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
        
        spinner.color = .white
        spinner.translatesAutoresizingMaskIntoConstraints = false
        btnLogin.addSubview(spinner)
        NSLayoutConstraint.activate([
            spinner.centerYAnchor.constraint(equalTo: btnLogin.centerYAnchor),
            spinner.centerXAnchor.constraint(equalTo: btnLogin.centerXAnchor)
        ])
    }
    
    // MARK: - Rx Bindings
    private func setupBindings() {
        
        emailField.rx.text.orEmpty
            .bind(to: viewModel.emailText)
            .disposed(by: disposeBag)
        
        passwordField.rx.text.orEmpty
            .bind(to: viewModel.passwordText)
            .disposed(by: disposeBag)
        
        btnLogin.rx.tap
            .bind(to: viewModel.loginButtonTapped)
            .disposed(by: disposeBag)
        
        viewModel.isLoginEnabled
            .subscribe(onNext: { [weak self] isEnabled in
                guard let self else { return }
                btnLogin.isEnabled = isEnabled
                btnLogin.alpha = isEnabled ? 1.0 : 0.5
            })
            .disposed(by: disposeBag)
        
        viewModel.isLoading
            .subscribe(onNext: { [weak self] isLoading in
                guard let self else { return }
                if isLoading {
                    btnLogin.setTitle("", for: .normal)
                    spinner.startAnimating()
                } else {
                    btnLogin.setTitle("Login", for: .normal)
                    spinner.stopAnimating()
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.loginSuccess
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
    
    @IBAction func btnForgetTapped(_ sender: Any) {
        
    }
    
    @IBAction func btnSignupTapped(_ sender: Any) {
        let vc = RegisterVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func navigateToHome() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        
        let mainTabBar = HomeTabBarController()
        
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            window.rootViewController = mainTabBar
        }, completion: nil)
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Oops!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
}
