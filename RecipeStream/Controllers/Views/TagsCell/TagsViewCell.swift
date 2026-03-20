//
//  TagsViewCell.swift
//  RecipeStream
//
//  Created by Abanoob Samy on 20/03/2026.
//

import UIKit

class TagsViewCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tagLbl: UILabel!
    
    public static var identifier: String {
        get {
            return "TagsViewCell"
        }
    }
    
    public static func register() -> UINib {
        UINib(nibName: "TagsViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.round()
    }

    func configure(with text: String) {
        tagLbl.text = text
    }
}
