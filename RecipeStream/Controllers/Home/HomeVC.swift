//
//  HomeVC.swift
//  RecipeStream
//
//  Created by Abanoob Samy on 15/03/2026.
//

import UIKit
import Kingfisher

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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let greetingLbl = greetingsLbl else {
            print("❌Label Not Linked yet!")
            return
        }
        let greetings = Date().greeting
        greetingLbl.text = "\(greetings)"
    }
    
    func setupViews() {
        
        let user = SessionManager.currentUser
        titleLbl.text = user?.name ?? "No User Name"
        loadCircularProfileImage()
        
        notificationIv.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(logoutTapped(_:)))
        notificationIv.addGestureRecognizer(tap)
    }
    
    private func loadCircularProfileImage() {
        // 1. نجيب الرابط من الـ SessionManager
        guard let imageUrlString = SessionManager.currentUser?.profileImageUrl,
              let url = URL(string: imageUrlString) else {
            // لو ملوش صورة، حط صورة افتراضية
            imageIv.image = UIImage(named: "profile")
            return
        }
        
        let circularProcessor = RoundCornerImageProcessor(cornerRadius: imageIv.frame.width / 2, backgroundColor: .clear)
        
        imageIv.layer.masksToBounds = true
        imageIv.contentMode = .scaleAspectFill
        
        imageIv.kf.setImage(
            with: url,
            placeholder: UIImage(named: "profile"),
            options: [
                .processor(circularProcessor),
                .transition(.fade(0.2)),
                .cacheOriginalImage
            ]
        )
    }
    
    @objc func logoutTapped(_ sender: UITapGestureRecognizer) {
        SessionManager.clearSession()
        
        let vc = LoginVC()
        let navVC = UINavigationController(rootViewController: vc)
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return
        }
        
        window.rootViewController = navVC
        window.makeKeyAndVisible()
        
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        imageIv.layer.cornerRadius = imageIv.frame.width / 2
        
        // بنخلي الارتفاع بتاع الكولكشن يساوي طول المحتوى الحقيقي (ContentSize)
        let contentHeight = recommendedCollectionView.collectionViewLayout.collectionViewContentSize.height
        recommendedCVHeightConstraint.constant = contentHeight
    }
    
    @IBAction func btnSeeAll(_ sender: Any) {
    }
    
}
