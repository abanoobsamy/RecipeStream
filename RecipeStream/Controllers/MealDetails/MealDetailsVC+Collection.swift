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

extension MealDetailsVC {
    
    func setupCollectionViews() {
        tagsCollectionView.register(TagsViewCell.register(), forCellWithReuseIdentifier: TagsViewCell.identifier)
        ingredientsCollectionView.register(IngredientsViewCell.register(), forCellWithReuseIdentifier: IngredientsViewCell.identifier)
        instructionsCollectionView.register(InstructionsViewCell.register(), forCellWithReuseIdentifier: InstructionsViewCell.identifier)
        
        let collections = [tagsCollectionView, ingredientsCollectionView, instructionsCollectionView]
        
        collections.forEach {
            $0?.backgroundColor = .clear
            $0?.showsHorizontalScrollIndicator = false
            $0?.showsVerticalScrollIndicator = false
        }
        
        tagsCollectionView.collectionViewLayout = createTagsLayout()
        ingredientsCollectionView.collectionViewLayout = createListLayout()
        instructionsCollectionView.collectionViewLayout = createListLayout()
    }
    
    private func createTagsLayout() -> UICollectionViewLayout {
        // We use Estimated Height/Width to automatically expand the capsule according to the word length
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(100), heightDimension: .absolute(32))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(32))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(8) // Horizontal distance between capsules
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8 // Vertical spacing between rows if there are multiple rows
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        // If you want it to scroll horizontally only (not in zigzag rows), add this line:
//        section.orthogonalScrollingBehavior = .continuous
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    // Planning vertical lists (quantities and instructions)
    private func createListLayout() -> UICollectionViewLayout {
        // We use Estimated Height to expand the row if the text is long
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 16 // Vertical distance between each component/step
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}
