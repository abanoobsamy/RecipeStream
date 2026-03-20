//
//  RecomendedCellViewCell.swift
//  RecipeStream
//
//  Created by Abanoob Samy on 16/03/2026.
//

import UIKit
import Kingfisher

class RecommendedViewCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageIv: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var favoriteIv: UIImageView!
    
    public static var identifier: String {
        get {
            return "RecommendedViewCell"
        }
    }
    
    public static func register() -> UINib {
        UINib(nibName: "RecommendedViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        favoriteIv.makeCircularIcon(bgColor: .systemGray6)
        containerView.round(20)
    }

    func configure(with model: Recipe) {
        titleLbl.text = model.name ?? ""
        descLbl.text = "\(model.difficulty ?? "") \(model.cuisine ?? "") \(model.caloriesPerServing ?? 0) kcal \(model.cookTimeMinutes ?? 0) min"
        
        loadImage(imageUrl: model.image ?? "")
    }
    
    private func loadImage(imageUrl: String) {
        let url = URL(string: imageUrl)
        
        imageIv.layer.masksToBounds = true
        imageIv.contentMode = .scaleAspectFill
        
        imageIv.kf.setImage(
            with: url,
            placeholder: UIImage(named: "profile"),
            options: [
                .transition(.fade(0.2)),
                .cacheOriginalImage
            ]
        )
    }
}
