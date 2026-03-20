//
//  InstructionsViewCell.swift
//  RecipeStream
//
//  Created by Abanoob Samy on 20/03/2026.
//

import UIKit

class InstructionsViewCell: UICollectionViewCell {

    @IBOutlet weak var numberLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var containerCountView: UIView!

    public static var identifier: String {
        get {
            return "InstructionsViewCell"
        }
    }
    
    public static func register() -> UINib {
        UINib(nibName: "InstructionsViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containerCountView.makeCircular()
    }

    func configure(with title: String, number: Int) {
        numberLbl.text = "\(number)"
        titleLbl.text = title
    }
}
