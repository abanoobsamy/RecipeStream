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
    
    // MARK: - Source of Truth
    private let allRecipes = BehaviorRelay<[Recipe]>(value: [])
    
    // MARK: - Inputs (Events come from UI)
    let pullToRefresh = PublishRelay<Void>()
    let selectedCategory = BehaviorRelay<String>(value: "All")
    
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
        setupReactiveFiltering()
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
    
    private func setupReactiveFiltering() {
        // We monitor any changes that occur in "All Recipes" or "Selected Category"
        RxSwift.Observable.combineLatest(allRecipes, selectedCategory)
            .map { recipes, category -> [Recipe] in
                if category == "All" {
                    return recipes
                }
                // Filter recipes whose mealType array contains the specified category
                return recipes.filter { $0.mealType?.contains(category) ?? false }
            }
            .bind(to: recommendedItems) // send to UI
            .disposed(by: disposeBag)
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
                    self.extractAndSetCategories(from: recommendedRecipes)
                    self.allRecipes.accept(recommendedRecipes)
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
    
    // MARK: - Data Processing
    private func extractAndSetCategories(from recipes: [Recipe]) {
        // Extract all mealTypes, merge them into a single array, and remove duplicates using Set
        let uniqueCategories = Set(recipes.compactMap { $0.mealType }.flatMap { $0 })
        
        // Prepare the final array with "All" added at the beginning
        var finalCategories = ["All"]
        finalCategories.append(contentsOf: uniqueCategories.sorted())
        
        categoryItems.accept(finalCategories)
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
