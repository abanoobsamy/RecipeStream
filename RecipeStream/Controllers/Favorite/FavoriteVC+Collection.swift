//
//  HomeVC+SliderCollection.swift
//  RecipeStream
//
//  Created by Abanoob Samy on 16/03/2026.
//

import UIKit
import RxSwift
import RxCocoa

extension FavoriteVC: UICollectionViewDragDelegate, UICollectionViewDelegate {
    
    func setupCollectionViews() {
        collectionView.dragInteractionEnabled = true
        collectionView.dragDelegate = self
        
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        collectionView.register(FavoriteViewCell.register(), forCellWithReuseIdentifier: FavoriteViewCell.identifier)
        
        collectionView.backgroundColor = .clear
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let itemProvider = NSItemProvider()
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = indexPath
        return [dragItem]
    }
}
