//
//  SearchViewCell.swift
//  RecipeStream
//
//  Created by Abanoob Samy on 21/03/2026.
//

import UIKit
import Kingfisher

class SearchViewCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var favoriteIV: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var rateLbl: UILabel!
    @IBOutlet weak var reviewsLbl: UILabel!
    
    var onFavoriteTapped: (() -> Void)?
    
    private var isFavorite: Bool = false
    
    public static var identifier: String {
        get {
            return "SearchViewCell"
        }
    }
    
    public static func register() -> UINib {
        UINib(nibName: "SearchViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        setupFavoriteTap()
    }
    
    private func setupUI() {
        imageView.round(16)
        containerView.addBorder(color: .colorThinDark, width: 1.0)
        containerView.round(16)
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
        
        let rating = recipe.rating ?? 0.0
        rateLbl.text = String(format: "%.1f", rating)
        
        let reviews = recipe.reviewCount ?? 0
        reviewsLbl.text = "(\(reviews) reviews)"
        
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
