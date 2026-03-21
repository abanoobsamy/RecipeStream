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

    func configure(with item: IngredientItem) {
        let attributeString = NSMutableAttributedString(string: item.title)
        let fullRange = NSMakeRange(0, attributeString.length)
            
        if item.isChecked {
            btnCheckbox.setImage(UIImage(systemName: "checkmark.rectangle.portrait.fill"), for: .normal)
            btnCheckbox.tintColor = .colorRedGray
            
            attributeString.addAttribute(.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: fullRange)
            attributeString.addAttribute(.foregroundColor, value: UIColor.lightGray, range: fullRange)
            
        } else {
            btnCheckbox.setImage(UIImage(systemName: "checkmark.rectangle.portrait"), for: .normal)
            btnCheckbox.tintColor = .colorOrange
            
            attributeString.addAttribute(.foregroundColor, value: UIColor.black, range: fullRange)
        }
        
        titleLbl.attributedText = attributeString
    }
    
}
