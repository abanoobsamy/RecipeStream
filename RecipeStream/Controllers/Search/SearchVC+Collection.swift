//
//  HomeVC+SliderCollection.swift
//  RecipeStream
//
//  Created by Abanoob Samy on 16/03/2026.
//

import UIKit
import RxSwift
import RxCocoa

extension SearchVC {
    
    func setupCollectionViews() {
        categoryCollectionView.register(CategoryViewCell.register(), forCellWithReuseIdentifier: CategoryViewCell.identifier)
        resultsCollectionView.register(SearchViewCell.register(), forCellWithReuseIdentifier: SearchViewCell.identifier)
        
        let collections = [categoryCollectionView, resultsCollectionView]
        
        collections.forEach {
            $0?.rx.setDelegate(self).disposed(by: disposeBag)
            $0?.backgroundColor = .clear
            $0?.showsHorizontalScrollIndicator = false
            $0?.showsVerticalScrollIndicator = false
        }
    }
}

extension SearchVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == categoryCollectionView {
            let items = viewModel.categories.value
            guard indexPath.item < items.count else { return CGSize(width: 100, height: 32) }
            let categoryName = items[indexPath.item]
            
            let font = UIFont.systemFont(ofSize: 14, weight: .bold)
            let textWidth = categoryName.size(withAttributes: [.font: font]).width
            let totalWidth = textWidth + 32
            
            return CGSize(width: totalWidth, height: 32)
            
        } else {
            return CGSize(width: collectionView.frame.width, height: 120)
        }
    }
    
    // المسافة الرأسية بين كل صف والتاني
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == categoryCollectionView {
            return 1
        } else {
            return 16
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == categoryCollectionView {
            return 12
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == categoryCollectionView {
            return UIEdgeInsets(top: 1, left: 2, bottom: 1, right: 2)
        } else {
            return UIEdgeInsets(top: 0, left: 0, bottom: 56, right: 0)
        }
    }
}

