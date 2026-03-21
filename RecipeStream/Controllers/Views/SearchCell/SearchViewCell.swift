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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        imageView.round(16)
        containerView.addBorder(color: .colorGrayBlue, width: 0.5)
        containerView.round(16)
    }
    
    func configure(with recipe: Recipe) {
        titleLbl.text = recipe.name ?? "Unknown Recipe"
        
        let time = recipe.cookTimeMinutes ?? 0 + (recipe.prepTimeMinutes ?? 0)
        let difficulty = recipe.difficulty ?? "Unknown"
        timeLbl.text = "\(time) mins • \(difficulty)"
        
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
