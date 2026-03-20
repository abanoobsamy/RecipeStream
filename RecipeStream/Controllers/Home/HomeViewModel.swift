//
//  HomeViewModel.swift
//  RecipeStream
//
//  Created by Abanoob Samy on 20/03/2026.
//

import Foundation
import RxSwift
import RxCocoa

class HomeViewModel {
    
    // MARK: - Inputs (Events come from UI)
    let pullToRefresh = PublishRelay<Void>()
    
    // MARK: - Outputs (Data going to UI)
    let sliderItems = BehaviorRelay<[Recipe]>(value: [])
    let categoryItems = BehaviorRelay<[String]>(value: [])
    let recommendedItems = BehaviorRelay<[Recipe]>(value: [])
    
    let isLoading = BehaviorRelay<Bool>(value: false)
    let errorMessage = PublishRelay<String>()
    
    let currentSlideIndex = BehaviorRelay<Int>(value: 0)
    
    private let disposeBag = DisposeBag()
    private var timer: Timer?
    
    init() {
        setupCategories()
        fetchSliderRecipes(limit: 5)
        fetchRecipes(limit: 10)
        bindInputs()
    }
    
    private func bindInputs() {
        pullToRefresh
            .subscribe(onNext: { [weak self] in
                self?.fetchSliderRecipes(limit: 5)
                self?.fetchRecipes(limit: 10)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupCategories() {
        let foodCategories = ["All", "Breakfast", "Lunch", "Dinner", "Dessert", "Vegan", "Keto", "Seafood"]
        categoryItems.accept(foodCategories)
    }
    
    // MARK: - API Calls
    func fetchSliderRecipes(limit: Int) {
        isLoading.accept(true)
        
        let params: [String: Any] = ["limit": limit]
        NetworkManager.shared.request(RecipeRouter.getAllRecipes(parameters: params))
            .subscribe(onSuccess: { [weak self] (response: RecipeResponse) in
                guard let self = self else { return }
                
                isLoading.accept(false)
                
                if let newRecipes = response.recipes {
                    sliderItems.accept(newRecipes)
                    startSliderTimer()
                }
                
            }, onFailure: { [weak self] error in
                guard let self = self else { return }
                isLoading.accept(false)
                errorMessage.accept(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - API Calls
    func fetchRecipes(limit: Int) {
        isLoading.accept(true)
        
        let params: [String: Any] = ["limit": limit]
        NetworkManager.shared.request(RecipeRouter.getAllRecipes(parameters: params))
            .subscribe(onSuccess: { [weak self] (response: RecipeResponse) in
                guard let self = self else { return }
                
                isLoading.accept(false)
                
                if let newRecipes = response.recipes {
                    recommendedItems.accept(newRecipes)
                }
                
            }, onFailure: { [weak self] error in
                guard let self = self else { return }
                isLoading.accept(false)
                errorMessage.accept(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    private func startSliderTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            let totalItems = sliderItems.value.count
            if totalItems == 0 { return }
            
            var nextIndex = currentSlideIndex.value + 1
            if nextIndex >= totalItems {
                nextIndex = 0
            }
            currentSlideIndex.accept(nextIndex) // send index to UI
        }
    }
    
    deinit {
        timer?.invalidate()
    }
}
