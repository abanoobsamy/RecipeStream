//
//  FavoriteVC.swift
//  RecipeStream
//
//  Created by Abanoob Samy on 21/03/2026.
//

import UIKit
import RxSwift
import RxCocoa

class FavoriteVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var emptyStateView: UIView!
    
    let viewModel = FavoriteViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionViews()
        setupModernLayout()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchFavorites()
    }
    
    private func setupModernLayout() {
        // Create a list-style layout to support drag
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        config.backgroundColor = .clear
        config.showsSeparators = false
        
        // Enable the swipe left to delete feature
        config.trailingSwipeActionsConfigurationProvider = { [weak self] indexPath in
            let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { action, view, completion in
                self?.viewModel.deleteFavorite(at: indexPath.item)
                completion(true)
            }
            deleteAction.image = UIImage(systemName: "trash.fill")
            return UISwipeActionsConfiguration(actions: [deleteAction])
        }
        
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        collectionView.collectionViewLayout = layout
    }
    
    private func bindViewModel() {
        
        viewModel.favorites
            .bind(to: collectionView.rx.items(cellIdentifier: FavoriteViewCell.identifier, cellType: FavoriteViewCell.self)) { (row, recipe, cell) in
                cell.configure(with: recipe, isFav: true)
                cell.favoriteIV.isHidden = true
                // not needed
//                cell.onFavoriteTapped = { [weak self] in
//                    self?.viewModel.deleteFavorite(at: row)
//                }
            }
            .disposed(by: disposeBag)
        
        viewModel.isEmpty
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] empty in
                self?.emptyStateView.isHidden = !empty
                self?.collectionView.isHidden = empty
            })
            .disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(Recipe.self)
            .subscribe(onNext: { [weak self] recipe in
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
