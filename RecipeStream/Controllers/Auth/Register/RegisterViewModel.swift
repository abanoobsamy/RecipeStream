//
//  RegisterViewModel.swift
//  RecipeStream
//
//  Created by Abanoob Samy on 19/03/2026.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

class RegisterViewModel {
    
    private let authService: AuthServiceProtocol
    private let disposeBag = DisposeBag()
    
    let nameText = BehaviorRelay<String>(value: "")
    let emailText = BehaviorRelay<String>(value: "")
    let passwordText = BehaviorRelay<String>(value: "")
    let confirmPassText = BehaviorRelay<String>(value: "")
    let isChecked = BehaviorRelay<Bool>(value: false)
    let selctedImage = BehaviorRelay<UIImage?>(value: nil)
    let registerButtonTapped = PublishRelay<Void>()
    
    let isRegEnabled: RxSwift.Observable<Bool>
    let isLoading = BehaviorRelay<Bool>(value: false)
    let registerSuccess = PublishRelay<Void>()
    let errorMessage = PublishRelay<String>()
    
    private let generatedUniqueUsername = BehaviorRelay<String?>(value: nil)
    
    init(authService: AuthServiceProtocol = AuthService()) {
        self.authService = authService
                
        let username = generatedUniqueUsername.asObservable()
        let name = nameText.asObservable()
        let email = emailText.asObservable()
        let password = passwordText.asObservable()
        let confirmPass = confirmPassText.asObservable()
        let isChecked = isChecked.asObservable()
        let image = selctedImage.asObservable()
        
        isRegEnabled = RxSwift.Observable.combineLatest(
            username,
            name,
            email,
            password,
            confirmPass,
            isChecked,
            image
        ) { username, name, email, password, confirmPass, isChecked, image in
            
            let isNameValid = !name.isEmpty
            let isEmailValid = email.contains("@") && email.contains(".")
            let isPasswordValid = password.count >= 6 && password == confirmPass
            let isImageSelected = image != nil
            let isUsernameReady = username != nil
            
            return isNameValid && isEmailValid && isPasswordValid && isChecked && isImageSelected && isUsernameReady
        }
        
        registerButtonTapped
            .withLatestFrom(RxSwift.Observable.combineLatest(
                username,
                name,
                email,
                password,
                confirmPass,
                isChecked,
                image)
            )
            .subscribe(onNext: { [weak self] username, name, email, password, confirmPass, isChecked, image in
                guard let self else { return }
                
                let finalUsernameToRegister = username ?? name.lowercased().replacingOccurrences(of: " ", with: ".")

                performRegister(username: finalUsernameToRegister, name: name, email: email, password: password, image: image)
            })
            .disposed(by: disposeBag)
        
        setupAutomaticUsernameGeneration()
    }
    
    func performRegister(username: String, name: String, email: String, password: String, image: UIImage?) {
        isLoading.accept(true)
                
        authService.signUp(username: username, name: name, email: email, password: password, profileImage: image)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .observe(on: MainScheduler.instance)
            .subscribe(
                onCompleted: { [weak self] in
                    guard let self else { return }
                    isLoading.accept(false)
                    registerSuccess.accept(())
                },
                onError: { [weak self] (error: Error) in
                    guard let self else { return }
                    isLoading.accept(false)
                    errorMessage.accept(error.localizedDescription)
                }
            )
            .disposed(by: disposeBag)
        
    }

    private func setupAutomaticUsernameGeneration() {
        nameText.asObservable()
            .debounce(.milliseconds(800), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .filter { !$0.isEmpty && $0.count >= 3 }
            .flatMapLatest { [weak self] fullName -> RxSwift.Observable<String> in
                guard let self = self else { return RxSwift.Observable.just("") }
                
                let components = fullName.lowercased().components(separatedBy: .whitespaces).filter { !$0.isEmpty }
                let baseName = components.joined(separator: ".")
                
                return checkAndGenerateRecursive(currentAttempt: baseName, baseName: baseName)
                    .asObservable() // تحويل Single لـ Observable
                    .catchAndReturn("")
            }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] finalUsername in
                if !finalUsername.isEmpty {
                    self?.generatedUniqueUsername.accept(finalUsername)
                    print("✅ Network Success: \(finalUsername)")
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func checkAndGenerateRecursive(currentAttempt: String, baseName: String) -> Single<String> {
        return FirestoreManager.shared.isUsernameAvailable(username: currentAttempt)
            .flatMap { isAvailable -> Single<String> in
                if isAvailable {
                    return .just(currentAttempt)
                } else {
                    let randomNumber = Int.random(in: 10...999)
                    let newAttempt = "\(baseName)\(randomNumber)"
                    return self.checkAndGenerateRecursive(currentAttempt: newAttempt, baseName: baseName)
                }
            }
    }
}
