//
//  LoginViewModel.swift
//  RecipeStream
//
//  Created by Abanoob Samy on 18/03/2026.
//

import Foundation
import RxSwift
import RxCocoa

class LoginViewModel {
    
    private let authService: AuthServiceProtocol
    private let disposeBag = DisposeBag()
    
    let emailText = BehaviorRelay<String>(value: "")
    let passwordText = BehaviorRelay<String>(value: "")
    let loginButtonTapped = PublishRelay<Void>()
    
    let isLoginEnabled: RxSwift.Observable<Bool>
    let isLoading = BehaviorRelay<Bool>(value: false)
    let loginSuccess = PublishRelay<Void>()
    let errorMessage = PublishRelay<String>()
    
    init(authService: AuthServiceProtocol = AuthService()) {
        self.authService = authService
        
        isLoginEnabled = RxSwift.Observable.combineLatest(
            emailText.asObservable(),
            passwordText.asObservable()
        ) { email, password in
            return !email.isEmpty && password.count >= 6
        }
        
        loginButtonTapped
            .withLatestFrom(RxSwift.Observable.combineLatest(
                emailText.asObservable(),
                passwordText.asObservable())
            )
            .subscribe(onNext: { [weak self] email, password in
                guard let self else { return }
                performLogin(email: email, password: password)
            })
            .disposed(by: disposeBag)
    }
    
    func performLogin(email: String, password: String) {
        isLoading.accept(true)
        
        authService.login(email: email, password: password)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .observe(on: MainScheduler.instance)
            .subscribe(
                onCompleted: { [weak self] in
                    guard let self else { return }
                    isLoading.accept(false)
                    loginSuccess.accept(())
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

