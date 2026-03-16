//
//  RecomendedCellViewCell.swift
//  RecipeStream
//
//  Created by Abanoob Samy on 16/03/2026.
//

import UIKit

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
        
        imageIv.image = UIImage(named: "img_1")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        favoriteIv.makeCircularIcon(bgColor: .systemGray6)
        containerView.round(20)
    }

}
