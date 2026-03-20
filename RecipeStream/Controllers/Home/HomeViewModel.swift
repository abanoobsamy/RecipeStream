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
        fetchAllData()
        bindInputs()
    }
    
    private func bindInputs() {
        pullToRefresh
            .subscribe(onNext: { [weak self] in
                self?.fetchAllData()
            })
            .disposed(by: disposeBag)
    }
    
    private func setupCategories() {
        let foodCategories = ["All", "Breakfast", "Lunch", "Dinner", "Dessert", "Vegan", "Keto", "Seafood"]
        categoryItems.accept(foodCategories)
    }
    
    // MARK: - API Calls
    func fetchAllData() {
        isLoading.accept(true)
        
        let sliderRequest: RxSwift.Observable<RecipeResponse> = NetworkManager.shared.request(RecipeRouter.getAllRecipes(parameters: ["limit": 5]))
            .asObservable()
        
        let recommendedRequest: RxSwift.Observable<RecipeResponse> = NetworkManager.shared.request(RecipeRouter.getAllRecipes(parameters: ["limit": 10]))
            .asObservable()
        
        let minDelay = RxSwift.Observable<Int>.timer(.seconds(3), scheduler: MainScheduler.instance)
        
        RxSwift.Observable.zip(sliderRequest, recommendedRequest, minDelay)
            .subscribe(onNext: { [weak self] (sliderResponse, recommendedResponse, _ ) in
                guard let self = self else { return }
                
                if let sliderRecipes = sliderResponse.recipes {
                    self.sliderItems.accept(sliderRecipes)
                    self.startSliderTimer()
                }
                
                if let recommendedRecipes = recommendedResponse.recipes {
                    self.recommendedItems.accept(recommendedRecipes)
                }
                
            }, onError: { [weak self] error in
                self?.isLoading.accept(false)
                self?.errorMessage.accept(error.localizedDescription)
                
            }, onCompleted: { [weak self] in
                // zip show after 3 sec from getting data
                self?.isLoading.accept(false)
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
