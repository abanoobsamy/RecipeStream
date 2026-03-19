//
//  RegisterViewModel.swift
//  RecipeStream
//
//  Created by Abanoob Samy on 19/03/2026.
//

import Foundation
import RxSwift
import RxCocoa

class RegisterViewModel {
    
    private let authService: AuthServiceProtocol
    private let disposeBag = DisposeBag()
    
    let nameText = BehaviorRelay<String>(value: "")
    let emailText = BehaviorRelay<String>(value: "")
    let passwordText = BehaviorRelay<String>(value: "")
    let confirmPassText = BehaviorRelay<String>(value: "")
    let isChecked = BehaviorRelay<Bool>(value: false)
    let registerButtonTapped = PublishRelay<Void>()
    
    let isRegEnabled: RxSwift.Observable<Bool>
    let isLoading = BehaviorRelay<Bool>(value: false)
    let registerSuccess = PublishRelay<Void>()
    let errorMessage = PublishRelay<String>()
    
    init(authService: AuthServiceProtocol = AuthService()) {
        self.authService = authService
        
        isRegEnabled = RxSwift.Observable.combineLatest(
            nameText.asObservable(),
            emailText.asObservable(),
            passwordText.asObservable(),
            confirmPassText.asObservable(),
            isChecked.asObservable()
        ) { name, email, password, confirmPass, isChecked in
            return !name.isEmpty && !email.isEmpty && password.count >= 6 && password == confirmPass && isChecked
        }
        
        registerButtonTapped
            .withLatestFrom(RxSwift.Observable.combineLatest(
                nameText.asObservable(),
                emailText.asObservable(),
                passwordText.asObservable(),
                confirmPassText.asObservable(),
                isChecked.asObservable())
            )
            .subscribe(onNext: { [weak self] name, email, password, confirmPass, isChecked in
                guard let self else { return }
                performRegister(name: name, email: email, password: password)
            })
            .disposed(by: disposeBag)
    }
    
    func performRegister(name: String, email: String, password: String) {
        isLoading.accept(true)
        
        authService.signUp(name: name, email: email, password: password)
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
}
