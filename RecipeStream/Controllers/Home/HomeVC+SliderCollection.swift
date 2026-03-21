//
//  HomeVC+SliderCollection.swift
//  RecipeStream
//
//  Created by Abanoob Samy on 16/03/2026.
//

import UIKit
import RxSwift
import RxCocoa
import Lottie

extension HomeVC {
    
    func setupCollectionViews() {
        sliderCollectionView.register(SliderHomeViewCell.register(), forCellWithReuseIdentifier: SliderHomeViewCell.identifier)
        categoryCollectionView.register(CategoryViewCell.register(), forCellWithReuseIdentifier: CategoryViewCell.identifier)
        recommendedCollectionView.register(RecommendedViewCell.register(), forCellWithReuseIdentifier: RecommendedViewCell.identifier)
        
//        sliderCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
//        categoryCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
//        recommendedCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        let collections = [sliderCollectionView, categoryCollectionView, recommendedCollectionView]
        
        collections.forEach {
            $0?.rx.setDelegate(self).disposed(by: disposeBag)
            $0?.backgroundColor = .clear
            $0?.showsHorizontalScrollIndicator = false
            $0?.showsVerticalScrollIndicator = false
        }
        
        sliderCollectionView.contentInsetAdjustmentBehavior = .never
    }
    
    func showPuddingLoader(show: Bool, width: CGFloat = 150, height: CGFloat = 150) {
        let loaderTag = 999
        let blurTag = 888
        
        if show {
            let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
            blurView.tag = blurTag
            blurView.translatesAutoresizingMaskIntoConstraints = false
//            view.addSubview(blurView)
            // to show above Tab Bar
            let superviewForBlur: UIView
            if let windowScene = view.window?.windowScene ?? UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first(where: { $0.isKeyWindow }) ?? windowScene.windows.first {
                window.addSubview(blurView)
                superviewForBlur = window
            } else {
                view.addSubview(blurView)
                superviewForBlur = view
            }
            
            NSLayoutConstraint.activate([
                blurView.topAnchor.constraint(equalTo: superviewForBlur.topAnchor),
                blurView.leadingAnchor.constraint(equalTo: superviewForBlur.leadingAnchor),
                blurView.trailingAnchor.constraint(equalTo: superviewForBlur.trailingAnchor),
                blurView.bottomAnchor.constraint(equalTo: superviewForBlur.bottomAnchor)
            ])
            
            let animationView = LottieAnimationView(name: "burrito")
            animationView.tag = loaderTag
            animationView.contentMode = .scaleAspectFit
            animationView.loopMode = .loop
            animationView.translatesAutoresizingMaskIntoConstraints = false
            
            superviewForBlur.addSubview(animationView)
            
            NSLayoutConstraint.activate([
                animationView.widthAnchor.constraint(equalToConstant: width),
                animationView.heightAnchor.constraint(equalToConstant: height),
                animationView.centerXAnchor.constraint(equalTo: superviewForBlur.centerXAnchor),
                animationView.centerYAnchor.constraint(equalTo: superviewForBlur.centerYAnchor)
            ])
            
            animationView.play()
        } else {
            if let windowScene = view.window?.windowScene ?? UIApplication.shared.connectedScenes.first as? UIWindowScene {
                let windows = windowScene.windows
                if let loaderView = (windows.compactMap { $0.viewWithTag(loaderTag) }.first ?? view.viewWithTag(loaderTag)) {
                    loaderView.removeFromSuperview()
                }
                if let blurView = (windows.compactMap { $0.viewWithTag(blurTag) }.first ?? view.viewWithTag(blurTag)) {
                    blurView.removeFromSuperview()
                }
            } else {
                view.viewWithTag(loaderTag)?.removeFromSuperview()
                view.viewWithTag(blurTag)?.removeFromSuperview()
            }
        }
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
            
            let font = UIFont.systemFont(ofSize: 14, weight: .bold)
            let textWidth = categoryName.size(withAttributes: [.font: font]).width
            let totalWidth = textWidth + 64
            
            return CGSize(width: totalWidth, height: 32)
            
        } else {
            // 1. سطر الحماية (Guard) لمنع القيم السالبة عند بدء التحميل
            guard collectionView.frame.width > 0 else {
                return CGSize(width: 150, height: 240) // مقاس افتراضي آمن
            }
            
            let isLandscape = self.view.bounds.width > self.view.bounds.height
            let numberOfColumns: CGFloat = isLandscape ? 4 : 2
            
            // 2. حساب المسافات
            let padding: CGFloat = 8
            let spacingBetweenCells: CGFloat = 8
            let totalSpacing = spacingBetweenCells * (numberOfColumns - 1)
            
            // الحسبة: عرض الشاشة - مسافات الحواف - المسافات الداخلية
            let availableWidth = collectionView.frame.width - (padding * 2) - totalSpacing
            
            // استخدمنا floor لضمان عدم وجود كسور تبوظ الـ Layout
            let cellWidth = floor(availableWidth / numberOfColumns)
            let cellHeight = isLandscape ? 240 : (cellWidth * 1.2)
            
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
            // 🚨 مهم جداً: يجب أن يتطابق الـ left والـ right هنا مع الـ padding الذي استخدمناه في معادلة الحجم (8)
            return UIEdgeInsets(top: 10, left: 8, bottom: 16, right: 8)
        }
    }
}

