//
//  SliderHomeViewCell.swift
//  RecipeStream
//
//  Created by Abanoob Samy on 16/03/2026.
//

import UIKit
import Kingfisher
import RxSwift
import RxCocoa

class SliderHomeViewCell: UICollectionViewCell {
    
    @IBOutlet weak var badgeView: UIView!
    @IBOutlet weak var badgeLbl: UILabel!
    @IBOutlet weak var imageIv: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var kcalLbl: UILabel!
    @IBOutlet weak var btnCook: UIButton!
    
    private var cellDisposeBag = DisposeBag()
    
    var onNavigateButtonTapped: (() -> Void)?
    
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
        setupGradient()
        setupBinding()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellDisposeBag = DisposeBag()
        setupBinding()
    }
    
    private func setupBinding() {
        btnCook.rx.tap
            .bind { [weak self] in
                self?.onNavigateButtonTapped?()
            }
            .disposed(by: cellDisposeBag)
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
    
    func configure(with model: Recipe) {
        titleLbl.text = model.name ?? ""
        kcalLbl.text = "\(model.caloriesPerServing ?? 0) kcal"
        timeLbl.text = "\(model.cookTimeMinutes ?? 0) min"
        badgeLbl.text = model.cuisine ?? ""
        
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
