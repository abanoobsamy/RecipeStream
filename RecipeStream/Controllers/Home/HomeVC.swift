//
//  HomeVC.swift
//  RecipeStream
//
//  Created by Abanoob Samy on 15/03/2026.
//

import UIKit
import Kingfisher
import RxSwift
import RxCocoa

class HomeVC: UIViewController {

    //outlets
    @IBOutlet weak var sliderCollectionView: UICollectionView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var recommendedCollectionView: UICollectionView!
    @IBOutlet weak var imageIv: UIImageView!
    @IBOutlet weak var seeAllBtn: UIButton!
    @IBOutlet weak var notificationIv: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var recommendedCVHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var greetingsLbl: UILabel!
    
    let viewModel = HomeViewModel()
    let disposeBag = DisposeBag()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationIv.makeCircularIcon(bgColor: .systemGray6)
        
        setupCollectionViews()
        setupViews()
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let greetingLbl = greetingsLbl else {
            print("❌Label Not Linked yet!")
            return
        }
        let greetings = Date().greeting
        greetingLbl.text = "\(greetings)"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Always guarantee the perfect round shape
        imageIv.layer.cornerRadius = imageIv.frame.width / 2
        imageIv.layer.masksToBounds = true
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        // Recalculating measurements seamlessly in sync with rotation
        coordinator.animate(alongsideTransition: { [weak self] _ in
            self?.sliderCollectionView.collectionViewLayout.invalidateLayout()
            self?.recommendedCollectionView.collectionViewLayout.invalidateLayout()
            self?.categoryCollectionView.collectionViewLayout.invalidateLayout()
            
            // Dynamically updating the height of the suggestions section instantly
            self?.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    // MARK: - Safe Area Handling
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        
        sliderCollectionView.contentInset = UIEdgeInsets(
            top: 0,
            left: view.safeAreaInsets.left,
            bottom: 0,
            right: view.safeAreaInsets.right
        )
        
        let tabBarAvoidancePadding: CGFloat = 100
        recommendedCollectionView.contentInset = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: tabBarAvoidancePadding,
            right: 0
        )
    }
    
    // MARK: - Setup Views
    func setupViews() {
        let user = SessionManager.currentUser
        titleLbl.text = user?.name ?? "No User Name"
        loadCircularProfileImage()
        
        notificationIv.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(notificationTapped(_:)))
        notificationIv.addGestureRecognizer(tap)
    }
    
    private func loadCircularProfileImage() {
        guard let imageUrlString = SessionManager.currentUser?.profileImageUrl,
              let url = URL(string: imageUrlString) else {
            imageIv.image = UIImage(named: "profile")
            return
        }
        
        imageIv.contentMode = .scaleAspectFill
        
        imageIv.kf.setImage(
            with: url,
            placeholder: UIImage(named: "profile"),
            options: [
                .transition(.fade(0.2)),
                .cacheOriginalImage
            ]
        )
    }
    
    // MARK: - ViewModel Binding
    private func bindViewModel() {
        
        viewModel.sliderItems
            .bind(to: sliderCollectionView.rx.items(cellIdentifier: SliderHomeViewCell.identifier, cellType: SliderHomeViewCell.self)) { (row, recipe, cell) in
                cell.configure(with: recipe)
                
                cell.onNavigateButtonTapped = { [weak self] in
                    self?.navigateToMealDetails(recipe: recipe)
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.sliderItems
            .map { $0.count }
            .bind(to: pageControl.rx.numberOfPages)
            .disposed(by: disposeBag)
        
        viewModel.currentSlideIndex
            .subscribe(onNext: { [weak self] index in
                guard let self = self, self.viewModel.sliderItems.value.count > 0 else { return }
                self.pageControl.currentPage = index
                let indexPath = IndexPath(item: index, section: 0)
                // Use DispatchQueue to ensure the cell exists before scrolling.
                DispatchQueue.main.async {
                    self.sliderCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.categoryItems
            .bind(to: categoryCollectionView.rx.items(cellIdentifier: CategoryViewCell.identifier, cellType: CategoryViewCell.self)) { (row, categoryName, cell) in
                cell.configure(title: categoryName, iconName: "fork.knife")
            }
            .disposed(by: disposeBag)
        
        viewModel.categoryItems
            .filter { !$0.isEmpty }
            .take(1)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                DispatchQueue.main.async {
                    let firstIndexPath = IndexPath(item: 0, section: 0)
                    self?.categoryCollectionView.selectItem(at: firstIndexPath, animated: false, scrollPosition: .centeredHorizontally)
                    
                    self?.viewModel.selectedCategory.accept("All")
                }
            })
            .disposed(by: disposeBag)
        
        categoryCollectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                
                let selectedCat = self.viewModel.categoryItems.value[indexPath.item]
                self.viewModel.selectedCategory.accept(selectedCat)
            })
            .disposed(by: disposeBag)
        
        viewModel.recommendedItems
            .observe(on: MainScheduler.instance)
            .bind(to: recommendedCollectionView.rx.items(cellIdentifier: RecommendedViewCell.identifier, cellType: RecommendedViewCell.self)) { (row, recipe, cell) in
                 cell.configure(with: recipe)
            }
            .disposed(by: disposeBag)
        
        recommendedCollectionView.rx.observe(CGSize.self, "contentSize")
            .compactMap { $0?.height }
            .distinctUntilChanged() // To avoid frequent updates of the same value
            .bind { [weak self] height in
                self?.recommendedCVHeightConstraint.constant = height + 10
            }
            .disposed(by: disposeBag)
        
        recommendedCollectionView.rx.itemSelected
            .withLatestFrom(viewModel.recommendedItems) { indexPath, items in
                return items[indexPath.item]
            }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] selectedRecipe in
                self?.navigateToMealDetails(recipe: selectedRecipe)
                
                // (Optional) Enable optical cell selection if needed
                if let selectedIndexPath = self?.recommendedCollectionView.indexPathsForSelectedItems?.first {
                    self?.recommendedCollectionView.deselectItem(at: selectedIndexPath, animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.isLoading
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] loading in
                self?.showPuddingLoader(show: loading)
            })
            .disposed(by: disposeBag)
    }
    
    func navigateToMealDetails(recipe: Recipe) {
        let detailsViewModel = DetailsViewModel(recipe: recipe)
        guard let vc = MealDetailsVC(viewModel: detailsViewModel) else { return }
        
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func notificationTapped(_ sender: UITapGestureRecognizer) {
        print("Notification Tapped")
    }
    
    @IBAction func btnSeeAll(_ sender: Any) {
        print("See All Tapped")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showPuddingLoader(show: false)
    }
}

