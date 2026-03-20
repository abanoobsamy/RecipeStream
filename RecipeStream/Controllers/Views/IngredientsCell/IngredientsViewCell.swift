//
//  IngredientsViewCell.swift
//  RecipeStream
//
//  Created by Abanoob Samy on 20/03/2026.
//

import UIKit

class IngredientsViewCell: UICollectionViewCell {
    
    @IBOutlet weak var btnCheckbox: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    
    public static var identifier: String {
        get {
            return "IngredientsViewCell"
        }
    }
    
    public static func register() -> UINib {
        UINib(nibName: "IngredientsViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(title: String) {
        self.titleLbl.text = title
    }
    
}
