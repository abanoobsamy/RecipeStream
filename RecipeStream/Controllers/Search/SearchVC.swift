//
//  SearchVC.swift
//  RecipeStream
//
//  Created by Abanoob Samy on 21/03/2026.
//

import UIKit
import RxSwift
import RxCocoa

class SearchVC: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var resultsCollectionView: UICollectionView!
    @IBOutlet weak var resultsCountLbl: UILabel!
    
    // MARK: - Properties
    let viewModel = SearchViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionViews()
        setupUI()
        bindViewModel()
    }
    
    // MARK: - Setup
    private func setupUI() {
        // Automatically hide the keyboard when the user scrolls (a professional UX touch)
        resultsCollectionView.keyboardDismissMode = .onDrag
        
//        searchBar.backgroundImage = UIImage()
    }

    // MARK: - Rx Bindings
    private func bindViewModel() {
        
        // Linking the text written in the search to the ViewModel (Input)
        searchBar.rx.text.orEmpty
            .bind(to: viewModel.searchText)
            .disposed(by: disposeBag)
        
        // Hide the keyboard when pressing the "Search" button on the keyboard
        searchBar.rx.searchButtonClicked
            .subscribe(onNext: { [weak self] in
                self?.searchBar.resignFirstResponder()
            })
            .disposed(by: disposeBag)
        
        // Linking the category array to the Category CollectionView (Output)
        viewModel.categories
            .bind(to: categoryCollectionView.rx.items(cellIdentifier: CategoryViewCell.identifier, cellType: CategoryViewCell.self)) { (row, categoryName, cell) in
                cell.configure(title: categoryName, iconName: "")
            }
            .disposed(by: disposeBag)
        
        // Programmatically determine the first class ("All") upon loading
        viewModel.categories
            .filter { !$0.isEmpty }
            .take(1)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                DispatchQueue.main.async {
                    let firstIndexPath = IndexPath(item: 0, section: 0)
                    self?.categoryCollectionView.selectItem(at: firstIndexPath, animated: false, scrollPosition: .centeredHorizontally)
                }
            })
            .disposed(by: disposeBag)
        
        // Listening to user clicks on categories and updating the ViewModel (Input)
        categoryCollectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                let selectedCat = self.viewModel.categories.value[indexPath.item]
                self.viewModel.selectedCategory.accept(selectedCat)
            })
            .disposed(by: disposeBag)
        
        // Link the filtered results to the Results CollectionView (Output)
        viewModel.searchResults
            .observe(on: MainScheduler.instance)
            .bind(to: resultsCollectionView.rx.items(cellIdentifier: SearchViewCell.identifier, cellType: SearchViewCell.self)) { (row, recipe, cell) in
                cell.configure(with: recipe)
            }
            .disposed(by: disposeBag)
        
        viewModel.resultsCountText
            .observe(on: MainScheduler.instance)
            .bind(to: resultsCountLbl.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.isLoading
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isLoading in
//                 self?.showPuddingLoader(show: isLoading)
            })
            .disposed(by: disposeBag)
        
        resultsCollectionView.rx.modelSelected(Recipe.self)
            .subscribe(onNext: { [weak self] selectedRecipe in
                 self?.navigateToMealDetails(recipe: selectedRecipe)
            })
            .disposed(by: disposeBag)
    }
    
    func navigateToMealDetails(recipe: Recipe) {
        let detailsViewModel = DetailsViewModel(recipe: recipe)
        guard let vc = MealDetailsVC(viewModel: detailsViewModel) else { return }
        
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        showPuddingLoader(show: false)
//    }
}
