//
//  HomeVC+SliderCollection.swift
//  RecipeStream
//
//  Created by Abanoob Samy on 16/03/2026.
//

import UIKit
import RxSwift
import RxCocoa

extension HomeVC {
    
    func setupCollectionViews() {
        sliderCollectionView.register(SliderHomeViewCell.register(), forCellWithReuseIdentifier: SliderHomeViewCell.identifier)
        categoryCollectionView.register(CategoryViewCell.register(), forCellWithReuseIdentifier: CategoryViewCell.identifier)
        recommendedCollectionView.register(RecommendedViewCell.register(), forCellWithReuseIdentifier: RecommendedViewCell.identifier)
        
        sliderCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        categoryCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        recommendedCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        sliderCollectionView.contentInsetAdjustmentBehavior = .never
        sliderCollectionView.backgroundColor = .clear
        categoryCollectionView.backgroundColor = .clear
        recommendedCollectionView.backgroundColor = .clear
    }
}

extension HomeVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == sliderCollectionView {
            let sliderWidth = sliderCollectionView.frame.width > 0 ? sliderCollectionView.frame.width : UIScreen.main.bounds.width
            return CGSize(width: sliderWidth, height: sliderCollectionView.frame.height)
            
        } else if collectionView == categoryCollectionView {
            let items = viewModel.categoryItems.value
            
            guard indexPath.item < items.count else { return CGSize(width: 100, height: 32) }
            let categoryName = items[indexPath.item]
            // 2. احسب عرض الكلمة
            let font = UIFont.systemFont(ofSize: 14, weight: .bold)
            let textWidth = categoryName.size(withAttributes: [.font: font]).width
            
            // 3. الحسبة الدقيقة:
            // عرض الكلمة + عرض الأيقونة (20) + المسافة بينهم (8) + مسافة الشمال (16) + مسافة اليمين (16)
            // يعني الإجمالي: textWidth + 60
            let totalWidth = textWidth + 64
            
            // 4. الارتفاع خليه 40 أو 45 (على حسب ما تحب الكبسولة تخينة ولا رفيعة)
            return CGSize(width: totalWidth, height: 32)
        } else {
            let padding: CGFloat = 8
            let spacingBetweenCells: CGFloat = 8
            
            // الحسبة: عرض الشاشة - (مسافة اليمين + مسافة الشمال + المسافة اللي في النص)
            let availableWidth = collectionView.frame.width - (padding * 2) - spacingBetweenCells
            
            // عرض الخلية الواحدة = المساحة المتبقية مقسومة على 2
            let cellWidth = availableWidth / 2
            
            // الارتفاع: الصورة باين إنها أطول من العرض شوية، ممكن نضرب العرض في 1.3 أو نحط رقم ثابت يعجبك
            let cellHeight = cellWidth * 1.2 // أو ممكن تكتب 240 مثلاً
            
            return CGSize(width: cellWidth, height: cellHeight)
        }
    }
    
    // المسافة الرأسية بين كل صف والتاني
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == sliderCollectionView {
            return 0
        } else if collectionView == categoryCollectionView {
            return 1
        } else {
            return 16
        }
    }
    
    // المسافة الأفقية بين العمودين
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == sliderCollectionView {
            return 4
        } else if collectionView == categoryCollectionView {
            return 12
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == sliderCollectionView {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        } else if collectionView == categoryCollectionView {
            return UIEdgeInsets(top: 1, left: 2, bottom: 1, right: 2)
        } else {
//            return UIEdgeInsets(top: 10, left: 16, bottom: 16, right: 16)
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        }
    }
}
