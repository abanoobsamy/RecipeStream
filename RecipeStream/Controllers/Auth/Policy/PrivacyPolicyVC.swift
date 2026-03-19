//
//  PrivacyPolicyVC.swift
//  RecipeStream
//
//  Created by Abanoob Samy on 18/03/2026.
//

import UIKit

class PrivacyPolicyVC: UIViewController {

    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var legalView: UIView!
    @IBOutlet weak var infoIV: UIImageView!
    @IBOutlet weak var infoContainerView: UIView!
    @IBOutlet weak var infoLineView: UIView!
    @IBOutlet weak var collectionView: UIView!
    @IBOutlet weak var collectionIV: UIImageView!
    @IBOutlet weak var colectionLineView: UIView!
    @IBOutlet weak var dataLineView: UIView!
    @IBOutlet weak var dataUsageIV: UIImageView!
    @IBOutlet weak var personalizationView: UIView!
    @IBOutlet weak var supportView: UIView!
    @IBOutlet weak var analyticsView: UIView!
    @IBOutlet weak var rightsLineView: UIView!
    @IBOutlet weak var rightsView: UIView!
    @IBOutlet weak var rightsIV: UIImageView!
    @IBOutlet weak var contactEmailView: UIView!
    
    @IBOutlet weak var dataUsageView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        setupToolbar()
        setupViews()
        setupCardSelection()
    }
    
    func setupToolbar() {
        self.title = "Privacy Policy"
    }
    
    func setupViews() {
        
        let views: [UIView?] = [
            infoContainerView,
            collectionView,
            dataUsageView,
            rightsView,
            contactEmailView
        ]
        views.compactMap { $0 }.forEach { (v: UIView) in
            v.round(.colorBGDark, 16)
        }
        
        let childViews: [UIView?] = [
            analyticsView,
            personalizationView,
            supportView,
        ]
        childViews.compactMap { $0 }.forEach { (v: UIView) in
            v.round(.colorThinDark, 4)
        }
        
        let ivImages: [UIImageView?] = [
            infoIV,
            collectionIV,
            dataUsageIV,
            rightsIV
        ]
        
        ivImages.compactMap { $0 }.forEach { (v: UIImageView) in
            v.makeRoundIcon(bgColor: .colorOrange, iconColor: .colorOrange, bgOpacity: 0.15, radius: 8)
        }
        
        legalView.addBorder(color: .colorOrange, width: 0.5)
        
        let linesViews: [UIView?] = [
            dataLineView,
            infoLineView,
            rightsLineView,
            colectionLineView,
        ]
        linesViews.compactMap { $0 }.forEach { (v: UIView) in
            v.round(4)
        }
        
        legalView.addCircularShadow(color: .colorOrange, opacity: 0.1, radius: 8)
        legalView.round(12)
        
    }
    
    private func setupCardSelection() {
        // 1. ندي لكل كارت رقم (Tag) عشان نميزهم
        infoContainerView.tag = 0
        collectionView.tag = 1
        dataUsageView.tag = 2
        rightsView.tag = 3
        
        // 2. نفعل الضغط على كل الكروت
        let cards = [infoContainerView, collectionView, dataUsageView, rightsView]
        for card in cards {
            card?.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(cardTapped(_:)))
            card?.addGestureRecognizer(tap)
        }
        
        // 3. نخلي كارت معين هو اللي متحدد في البداية (مثلاً الكارت الثاني زي صورتك)
        selectCard(at: 0)
    }

    // الدالة اللي بتشتغل لما تدوس على أي كارت
    @objc private func cardTapped(_ sender: UITapGestureRecognizer) {
        guard let tappedView = sender.view else { return }
        selectCard(at: tappedView.tag) // بنبعت رقم الكارت اللي انداس عليه
    }

    // دالة التحكم في الخطوط (The Senior Way)
    private func selectCard(at index: Int) {
        let allLines = [infoLineView, colectionLineView, dataLineView, rightsLineView]
        
        // بنعمل أنيميشن ناعم (0.3 ثانية) عشان الخط ميظهرش فجأة ويخض اليوزر
        UIView.animate(withDuration: 0.3) {
            for (i, line) in allLines.enumerated() {
                // التريكة هنا: الخط هيكون مخفي (true) لو رقمه مش نفس رقم الكارت اللي دوسنا عليه
                line?.isHidden = (i != index)
            }
        }
    }
}

