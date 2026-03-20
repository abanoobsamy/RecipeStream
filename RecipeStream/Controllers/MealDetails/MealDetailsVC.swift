//
//  MealDetailsVC.swift
//  RecipeStream
//
//  Created by Abanoob Samy on 20/03/2026.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class MealDetailsVC: UIViewController {
    
    //outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var kcalLbl: UILabel!
    @IBOutlet weak var levelLbl: UILabel!
    @IBOutlet weak var servingsLbl: UILabel!
    @IBOutlet weak var tagsCollectionView: UICollectionView!
    @IBOutlet weak var ingredientsCollectionView: UICollectionView!
    @IBOutlet weak var heightIngredientLayout: NSLayoutConstraint!
    @IBOutlet weak var instructionsCollectionView: UICollectionView!
    @IBOutlet weak var heightInsturctionLayout: NSLayoutConstraint!
    @IBOutlet weak var containerStack: UIStackView!
    @IBOutlet weak var containerContentView: UIView!
    
    let viewModel: DetailsViewModel
    let disposeBag = DisposeBag()
    
    // variables
    private let favoriteButton = UIButton(type: .system)
    private let shareButton = UIButton(type: .system)
    
    // will do later at view model
    private var isFavorite = false
    
    // inject ViewModel throw Coder
    init?(viewModel: DetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: MealDetailsVC.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("You must create this view controller with a view model.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRightBarButtons()
        setupNavigationBar()
        configView()
        setupCollectionViews()
        bindViewModel()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
                
        let contentHeight = ingredientsCollectionView.collectionViewLayout.collectionViewContentSize.height
        if contentHeight > 0 {
            heightIngredientLayout.constant = contentHeight
        }
        let instructionsContentHeight = instructionsCollectionView.collectionViewLayout.collectionViewContentSize.height
        if instructionsContentHeight > 0 {
            heightInsturctionLayout.constant = instructionsContentHeight
        }
    }
    
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        // هذا السطر هو السر لجعل الشريط شفافاً بالكامل
        appearance.configureWithTransparentBackground()
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        // تأكد من أن الأزرار (مثل الرجوع والمفضلة) بألوان تظهر بوضوح فوق الصورة
        navigationController?.navigationBar.tintColor = .white
        navigationItem.backButtonTitle = ""
    }
    
    func configView() {
        scrollView.contentInsetAdjustmentBehavior = .never
        
        containerStack.round(20)
        containerContentView.roundSpecificCorner(32, [.layerMinXMinYCorner, .layerMaxXMinYCorner])
    }
    
    func bindViewModel() {
                
        viewModel.imageUrl
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] url in
                guard let self = self, let url = url else { return }
                loadImage(imageUrl: url)
            })
            .disposed(by: disposeBag)
                
        viewModel.title
            .bind(to: titleLbl.rx.text)
            .disposed(by: disposeBag)
                
        viewModel.time
            .bind(to: timeLbl.rx.text)
            .disposed(by: disposeBag)
                
        viewModel.calories
            .bind(to: kcalLbl.rx.text)
            .disposed(by: disposeBag)
                
        viewModel.level
            .bind(to: levelLbl.rx.text)
            .disposed(by: disposeBag)
                
        viewModel.servings
            .bind(to: servingsLbl.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.tags
            .bind(to: tagsCollectionView.rx.items(cellIdentifier: TagsViewCell.identifier, cellType: TagsViewCell.self)) { (row, tag, cell) in
                cell.configure(with: tag)
            }
            .disposed(by: disposeBag)
        
        viewModel.ingredients
            .bind(to: ingredientsCollectionView.rx.items(cellIdentifier: IngredientsViewCell.identifier, cellType: IngredientsViewCell.self)) { (row, ingredient, cell) in
                cell.configure(title: ingredient)
            }
            .disposed(by: disposeBag)
        
        viewModel.instructions
            .bind(to: instructionsCollectionView.rx.items(cellIdentifier: InstructionsViewCell.identifier, cellType: InstructionsViewCell.self)) { (row, instruction, cell) in
                cell.configure(with: instruction, number: row + 1)
            }
            .disposed(by: disposeBag)
        
        ingredientsCollectionView.rx.observe(CGSize.self, "contentSize")
            .compactMap { $0?.height }
            .distinctUntilChanged() // To avoid frequent updates of the same value
            .bind { [weak self] height in
                self?.heightIngredientLayout.constant = height + 10
            }
            .disposed(by: disposeBag)

        instructionsCollectionView.rx.observe(CGSize.self, "contentSize")
            .compactMap { $0?.height }
            .distinctUntilChanged() // To avoid frequent updates of the same value
            .bind { [weak self] height in
                self?.heightInsturctionLayout.constant = height + 10
            }
            .disposed(by: disposeBag)
    }
    
    private func loadImage(imageUrl: URL) {
        self.imageView.kf.setImage(
            with: imageUrl,
            placeholder: UIImage(named: "placeholder"),
            options: [
                .transition(.fade(0.3)),
                .cacheOriginalImage
            ]
        )
    }
    
    private func setupRightBarButtons() {
        shareButton.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        shareButton.tintColor = .black
        shareButton.backgroundColor = UIColor.systemGray6
        shareButton.layer.cornerRadius = 17.5 // if size is 35x35
        shareButton.widthAnchor.constraint(equalToConstant: 35).isActive = true
        shareButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        shareButton.addTarget(self, action: #selector(shareTapped), for: .touchUpInside)
        
        let imageName = isFavorite ? "heart.fill" : "heart"

        favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
        favoriteButton.tintColor = .black
        favoriteButton.backgroundColor = UIColor.systemGray6
        favoriteButton.layer.cornerRadius = 17.5 // if size is 35x35
        favoriteButton.widthAnchor.constraint(equalToConstant: 35).isActive = true
        favoriteButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        favoriteButton.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)
        
        let shareBarButtonItem = UIBarButtonItem(customView: shareButton)
        let favoriteBarButtonItem = UIBarButtonItem(customView: favoriteButton)
        
        navigationItem.rightBarButtonItems = [shareBarButtonItem, favoriteBarButtonItem]
    }

    @objc private func shareTapped() {
        print("Share tapped")
    }

    @objc private func favoriteTapped() {
        print("Favorite tapped")

        isFavorite.toggle()
            
        let imageName = isFavorite ? "heart.fill" : "heart"
        let color: UIColor = isFavorite ? .red : .black
        
        favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
        favoriteButton.tintColor = color
        
        // Adding a subtle haptic feedback effect to give a professional feel
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
}

