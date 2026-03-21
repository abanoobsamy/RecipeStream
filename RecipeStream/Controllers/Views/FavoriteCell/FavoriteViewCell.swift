//
//  FavoriteViewCell.swift
//  RecipeStream
//
//  Created by Abanoob Samy on 21/03/2026.
//

import UIKit

class FavoriteViewCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var favoriteIV: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var caloriesLbl: UILabel!
    
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
    }
    
    private func setupUI() {
        favoriteIV.makeCircularIcon(bgColor: .systemGray6)
        containerView.round(20)
    }
}
