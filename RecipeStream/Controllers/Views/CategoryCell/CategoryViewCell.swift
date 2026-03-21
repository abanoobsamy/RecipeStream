//
//  CategoryViewCell.swift
//  RecipeStream
//
//  Created by Abanoob Samy on 16/03/2026.
//

import UIKit

class CategoryViewCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var iconIv: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    
    public static var identifier: String {
        get {
            return "CategoryViewCell"
        }
    }
    
    public static func register() -> UINib {
        UINib(nibName: "CategoryViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.round(12)
        setupUnselectedState()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        containerView.round(12)
    }
    
    func configure(title: String, iconName: String) {
        titleLbl.text = title
        if iconName.isEmpty {
            iconIv.isHidden = true
            titleLbl.textAlignment = .center
        } else {
            iconIv.isHidden = false
            iconIv.image = UIImage(systemName: iconName)
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                setupSelectedState()
            } else {
                setupUnselectedState()
            }
        }
    }
    
    func setupSelectedState() {
        containerView.backgroundColor = .colorRedGray
        titleLbl.textColor = .white
        iconIv.tintColor = .white
        
        containerView.addCircularShadow(color: .red, opacity: 0.3, radius: 5, offset: CGSize(width: 0, height: 3))
    }
    
    func setupUnselectedState() {
        containerView.backgroundColor = UIColor(red: 45/255, green: 45/255, blue: 45/255, alpha: 1.0)
        titleLbl.textColor = .lightGray
        iconIv.tintColor = .lightGray
        
        containerView.layer.shadowOpacity = 0
    }
}
