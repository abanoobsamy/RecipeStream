//
//  HomeVC.swift
//  RecipeStream
//
//  Created by Abanoob Samy on 15/03/2026.
//

import UIKit

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
    
    // variables
    var timer: Timer?
    var currentCellIndex: Int = 0
    
    var arrCategories: [String] = ["All", "Bob", "Abanoob", "Fixes Bob Bob Bob Bob "]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        navigationController?.isNavigationBarHidden = true
    
        notificationIv.makeCircularIcon(bgColor: .systemGray6)
        
        setupCollectionView()
        setupPager()
        setupViews()
        
        // بيعمل Select لأول عنصر (All) تلقائياً
        let firstIndexPath = IndexPath(item: 0, section: 0)
        categoryCollectionView.selectItem(at: firstIndexPath, animated: false, scrollPosition: .right)
    }
    
    func setupViews() {
        let user = SessionManager.currentUser
        titleLbl.text = user?.name ?? "No User Name"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // بنخلي الارتفاع بتاع الكولكشن يساوي طول المحتوى الحقيقي (ContentSize)
        let contentHeight = recommendedCollectionView.collectionViewLayout.collectionViewContentSize.height
        recommendedCVHeightConstraint.constant = contentHeight
    }
    
    @IBAction func btnSeeAll(_ sender: Any) {
    }
    
}
