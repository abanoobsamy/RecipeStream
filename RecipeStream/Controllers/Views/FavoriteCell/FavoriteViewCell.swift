//
//  FavoriteViewCell.swift
//  RecipeStream
//
//  Created by Abanoob Samy on 21/03/2026.
//

import UIKit
import Kingfisher

class FavoriteViewCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var favoriteIV: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var caloriesLbl: UILabel!
    
    var onFavoriteTapped: (() -> Void)?
    
    private var isFavorite: Bool = false

    public static var identifier: String {
        get {
            return "FavoriteViewCell"
        }
    }
    
    public static func register() -> UINib {
        UINib(nibName: "FavoriteViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        setupFavoriteTap()
    }
    
    private func setupUI() {
        favoriteIV.makeCircularIcon(bgColor: .systemGray6)
        containerView.round(20)
    }
    
    private func setupFavoriteTap() {
        favoriteIV.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(heartIconTapped))
        favoriteIV.addGestureRecognizer(tapGesture)
    }
    
    @objc private func heartIconTapped() {
        isFavorite.toggle()
        updateHeartUI()
        
        onFavoriteTapped?()
    }
    
    private func updateHeartUI() {
        let imageName = isFavorite ? "heart.fill" : "heart"
        favoriteIV.image = UIImage(systemName: imageName)
        favoriteIV.tintColor = isFavorite ? .red : .lightGray
    }
    
    func configure(with recipe: Recipe, isFav: Bool = false) {
        
        self.isFavorite = isFav
        updateHeartUI()
        
        titleLbl.text = recipe.name ?? "Unknown Recipe"
        
        let prepTime = recipe.prepTimeMinutes ?? 0
        let cookTime = recipe.cookTimeMinutes ?? 0
        let totalTime = prepTime + cookTime
        
        let difficulty = recipe.difficulty ?? "Unknown"
        timeLbl.text = "\(totalTime) mins • \(difficulty)"

        caloriesLbl.text = "\(recipe.caloriesPerServing ?? 0) kcal)"
        
        loadImage(imageUrl: recipe.image ?? "")
    }
    
    private func loadImage(imageUrl: String) {
        let url = URL(string: imageUrl)
        
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        imageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "profile"),
            options: [
                .transition(.fade(0.2)),
                .cacheOriginalImage
            ]
        )
    }
}
