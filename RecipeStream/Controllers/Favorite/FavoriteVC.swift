//
//  FavoriteVC.swift
//  RecipeStream
//
//  Created by Abanoob Samy on 21/03/2026.
//

import UIKit
import RxSwift
import RxCocoa
import Lottie

class FavoriteVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var emptyStateView: LottieAnimationView!
    
    let viewModel = FavoriteViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.bringSubviewToFront(emptyStateView)
        
        setupLottieConfiguration()
        setupCollectionViews()
        setupModernLayout()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchFavorites()

        if viewModel.favorites.value.isEmpty {
            emptyStateView.play()
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // Stop animation completely when leaving the screen to save resources
        emptyStateView.stop()
    }
    
    private func setupModernLayout() {
        // Create a list-style layout to support drag
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        config.backgroundColor = .clear
        config.showsSeparators = false
        
        // Enable the swipe left to delete feature
        config.trailingSwipeActionsConfigurationProvider = { [weak self] indexPath in
            let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { action, view, completion in
                self?.deleteFavorite(at: indexPath.item)
                completion(true)
            }
            deleteAction.image = UIImage(systemName: "trash.fill")
            return UISwipeActionsConfiguration(actions: [deleteAction])
        }
        
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        collectionView.collectionViewLayout = layout
    }
    
    func deleteFavorite(at index: Int) {
        let feedbackGenerator = UINotificationFeedbackGenerator()
        feedbackGenerator.notificationOccurred(.success)
        
        // to get position
        let indexPath = IndexPath(item: index, section: 0)
                
        collectionView.performBatchUpdates({
            self.viewModel.deleteFavorite(at: index)
            collectionView.deleteItems(at: [indexPath])
        }, completion: { finished in
            self.updateEmptyState()
        })
    }
    
    private func bindViewModel() {
        
        viewModel.favorites
            .bind(to: collectionView.rx.items(cellIdentifier: FavoriteViewCell.identifier, cellType: FavoriteViewCell.self)) { (row, recipe, cell) in
                cell.configure(with: recipe, isFav: true)
                cell.favoriteIV.isHidden = true
            }
            .disposed(by: disposeBag)
        
        // Monitoring changes to animation and Empty State
        viewModel.favorites
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] recipes in
                guard let self = self else { return }
                
                self.updateEmptyState()
                
                // We only update data if there is a significant difference.
                // Individual deletions are handled by performBatchUpdates.
                if recipes.count != self.collectionView.numberOfItems(inSection: 0) {
                    self.collectionView.reloadData()
                }
            })
            .disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(Recipe.self)
            .subscribe(onNext: { [weak self] recipe in
                self?.navigateToMealDetails(recipe: recipe)
            })
            .disposed(by: disposeBag)
    }
    
    private func updateEmptyState() {
        let isNowEmpty = viewModel.favorites.value.isEmpty
        
        UIView.animate(withDuration: 0.3) {
            self.emptyStateView.alpha = isNowEmpty ? 1.0 : 0.0
            self.collectionView.alpha = isNowEmpty ? 0.0 : 1.0
        } completion: { _ in
            if isNowEmpty {
                self.emptyStateView.play()
            } else {
                self.emptyStateView.pause()
            }
        }
    }
    
    func navigateToMealDetails(recipe: Recipe) {
        guard let recipeId = recipe.id else { return }
        
        //        let detailsViewModel = DetailsViewModel(recipe: recipe)
        let detailsViewModel = DetailsViewModel(recipeId: recipeId)
        guard let vc = MealDetailsVC(viewModel: detailsViewModel) else { return }
        
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setupLottieConfiguration() {
        let animation = LottieAnimation.named("bluebox_opened")
//        let animation = LottieAnimation.named("girl_withbox")
//        let animation = LottieAnimation.named("yellowbox_opened")

        emptyStateView.animation = animation
        emptyStateView.contentMode = .scaleAspectFit
        emptyStateView.loopMode = .loop
        emptyStateView.animationSpeed = 0.8
        emptyStateView.backgroundBehavior = .pauseAndRestore
        
        emptyStateView.alpha = 0
        
        print("Lottie Debug: Animation loaded? \(animation != nil)")
    }
}
