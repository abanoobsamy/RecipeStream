//
//  SeeAllVC.swift
//  RecipeStream
//
//  Created by Abanoob Samy on 22/03/2026.
//

import UIKit
import RxSwift
import RxCocoa

class SeeAllVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let viewModel = SeeAllViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionViews()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchFavoriteIDs()
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    private func bindViewModel() {
        
        let recipesWithFavState = RxSwift.Observable.combineLatest(
            viewModel.allRecipes,
            viewModel.favoriteIDs
        ).map { recipes, favIds -> [(Recipe, Bool)] in
            // We go through each recipe and ask: Is its ID present within the Set?
            return recipes.map { recipe in
                let isFav = favIds.contains(recipe.id ?? -1)
                return (recipe, isFav)
            }
        }
        
        // Link the filtered results to the Results CollectionView (Output)
        recipesWithFavState
            .observe(on: MainScheduler.instance)
            .bind(to: collectionView.rx.items(cellIdentifier: SearchViewCell.identifier, cellType: SearchViewCell.self)) { (row, item, cell) in
                
                let currentRecipe = item.0
                let isFavorite = item.1
                
                cell.configure(with: currentRecipe, isFav: isFavorite)
                
                cell.onFavoriteTapped = { [weak self] in
                    let generator = UISelectionFeedbackGenerator()
                    generator.selectionChanged()
                    self?.viewModel.toggleFavorite(recipe: currentRecipe)
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.isLoading
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isLoading in
                self?.showPuddingLoader(show: isLoading)
            })
            .disposed(by: disposeBag)
        
        collectionView.rx.modelSelected((Recipe, Bool).self)
            .subscribe(onNext: { [weak self] selectedItem in
                let recipe = selectedItem.0
                self?.navigateToMealDetails(recipe: recipe)
            })
            .disposed(by: disposeBag)
    }
        
    func navigateToMealDetails(recipe: Recipe) {
        guard let recipeId = recipe.id else { return }
        
//        let detailsViewModel = DetailsViewModel(recipe: recipe)
        let detailsViewModel = DetailsViewModel(recipeId: recipeId)
        guard let vc = MealDetailsVC(viewModel: detailsViewModel) else { return }
        
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}
