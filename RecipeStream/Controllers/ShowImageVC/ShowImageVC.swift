//
//  ShowImageVC.swift
//  Trending Movies
//
//  Created by Abanoob Samy on 12/03/2026.
//

import UIKit
import Kingfisher

class ShowImageVC: UIViewController {

    @IBOutlet weak var movieIv: UIImageView!
    
    var passedImage: URL?
        
    lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.minimumZoomScale = 1.0
        scroll.maximumZoomScale = 4.0
        scroll.delegate = self
        scroll.translatesAutoresizingMaskIntoConstraints = false
        
        // 🛑 The first secret here: We prevent the scroll wheel from pushing itself down because of the notch
        scroll.contentInsetAdjustmentBehavior = .never
        return scroll
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupGestures()
        
        loadImage(imageUrl: passedImage!)
        movieIv.isUserInteractionEnabled = true
    }
    
    private func loadImage(imageUrl: URL) {
        
        movieIv.layer.masksToBounds = true
        movieIv.contentMode = .scaleAspectFill
        
        movieIv.kf.setImage(
            with: imageUrl,
            placeholder: UIImage(named: "profile"),
            options: [
                .transition(.fade(0.2)),
                .cacheOriginalImage
            ]
        )
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        centerImage()
    }
    
    func centerImage() {
        let scrollViewSize = scrollView.bounds.size
        let imageSize = movieIv.frame.size
        
        let verticalPadding = imageSize.height < scrollViewSize.height ? (scrollViewSize.height - imageSize.height) / 2 : 0
        let horizontalPadding = imageSize.width < scrollViewSize.width ? (scrollViewSize.width - imageSize.width) / 2 : 0
        
        scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
    }
}
