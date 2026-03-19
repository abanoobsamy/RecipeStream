//
//  ProfileVC.swift
//  RecipeStream
//
//  Created by Abanoob Samy on 19/03/2026.
//

import UIKit
import Kingfisher

class ProfileVC: UIViewController {

    @IBOutlet weak var containerImgView: UIView!
    @IBOutlet weak var profileIV: UIImageView!
    @IBOutlet weak var btnSetting: UIButton!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var usernameLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        profileIV.layer.cornerRadius = profileIV.frame.width / 2
    }
    
    func setupViews() {
        let user = SessionManager.currentUser
        nameLbl.text = user?.name ?? "No Name"
        usernameLbl.text = "@\(user?.username ?? "No Username")"
        
        containerImgView.makeCircular(borderWidth: 1.5, borderColor: .colorOrange)
        loadCircularProfileImage()
    }
    
    private func loadCircularProfileImage() {
        // 1. نجيب الرابط من الـ SessionManager
        guard let imageUrlString = SessionManager.currentUser?.profileImageUrl,
              let url = URL(string: imageUrlString) else {
            // لو ملوش صورة، حط صورة افتراضية
            profileIV.image = UIImage(named: "profile")
            return
        }
        
        let circularProcessor = RoundCornerImageProcessor(cornerRadius: profileIV.frame.width / 2, backgroundColor: .clear)
        
        profileIV.layer.masksToBounds = true
        profileIV.contentMode = .scaleAspectFill
        
        profileIV.kf.setImage(
            with: url,
            placeholder: UIImage(named: "profile"),
            options: [
                .processor(circularProcessor),
                .transition(.fade(0.2)),
                .cacheOriginalImage
            ]
        )
    }
}
