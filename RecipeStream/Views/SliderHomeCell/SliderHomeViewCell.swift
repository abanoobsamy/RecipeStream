//
//  SliderHomeViewCell.swift
//  RecipeStream
//
//  Created by Abanoob Samy on 16/03/2026.
//

import UIKit

class SliderHomeViewCell: UICollectionViewCell {
    
    @IBOutlet weak var badgeView: UIView!
    @IBOutlet weak var badgeLbl: UILabel!
    @IBOutlet weak var imageIv: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var kcalLbl: UILabel!
    @IBOutlet weak var btnCook: UIButton!
    
    let gradientLayer = CAGradientLayer()
    
    public static var identifier: String {
        get {
            return "SliderHomeViewCell"
        }
    }
    
    public static func register() -> UINib {
        UINib(nibName: "SliderHomeViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        imageIv.image = UIImage(named: "img_1")
        setupGradient()
    }
    
    func setupGradient() {
        // بنقوله ابدأ من لون شفاف (Clear) وانتهي بلون أسود شفافيته 70%
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.black.withAlphaComponent(0.999).cgColor
        ]
        
        // دي تريكة الصياعة: بنقوله خلي أول 450% من الصورة فوق شفاف تماماً، وابدأ التدرج الأسود من النص لحد تحت
        gradientLayer.locations = [0.3, 1.0]
        imageIv.layer.addSublayer(gradientLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.frame = imageIv.bounds
        badgeView.round(12)
        imageIv.round(20)
    }
    
    @IBAction func btnCook(_ sender: Any) {
    }
    
}
