//
//  UIViewControllerExt.swift
//  RecipeStream
//
//  Created by Abanoob Samy on 21/03/2026.
//

import UIKit
import Lottie

extension UIViewController {
    
    // lottie file loader json
    func showPuddingLoader(show: Bool, width: CGFloat = 150, height: CGFloat = 150) {
        let loaderTag = 999
        let blurTag = 888
        
        if show {
            let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
            blurView.tag = blurTag
            blurView.translatesAutoresizingMaskIntoConstraints = false
//            view.addSubview(blurView)
            // to show above Tab Bar
            let superviewForBlur: UIView
            if let windowScene = view.window?.windowScene ?? UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first(where: { $0.isKeyWindow }) ?? windowScene.windows.first {
                window.addSubview(blurView)
                superviewForBlur = window
            } else {
                view.addSubview(blurView)
                superviewForBlur = view
            }
            
            NSLayoutConstraint.activate([
                blurView.topAnchor.constraint(equalTo: superviewForBlur.topAnchor),
                blurView.leadingAnchor.constraint(equalTo: superviewForBlur.leadingAnchor),
                blurView.trailingAnchor.constraint(equalTo: superviewForBlur.trailingAnchor),
                blurView.bottomAnchor.constraint(equalTo: superviewForBlur.bottomAnchor)
            ])
            
            let animationView = LottieAnimationView(name: "burrito")
            animationView.tag = loaderTag
            animationView.contentMode = .scaleAspectFit
            animationView.loopMode = .loop
            animationView.translatesAutoresizingMaskIntoConstraints = false
            
            superviewForBlur.addSubview(animationView)
            
            NSLayoutConstraint.activate([
                animationView.widthAnchor.constraint(equalToConstant: width),
                animationView.heightAnchor.constraint(equalToConstant: height),
                animationView.centerXAnchor.constraint(equalTo: superviewForBlur.centerXAnchor),
                animationView.centerYAnchor.constraint(equalTo: superviewForBlur.centerYAnchor)
            ])
            
            animationView.play()
        } else {
            if let windowScene = view.window?.windowScene ?? UIApplication.shared.connectedScenes.first as? UIWindowScene {
                let windows = windowScene.windows
                if let loaderView = (windows.compactMap { $0.viewWithTag(loaderTag) }.first ?? view.viewWithTag(loaderTag)) {
                    loaderView.removeFromSuperview()
                }
                if let blurView = (windows.compactMap { $0.viewWithTag(blurTag) }.first ?? view.viewWithTag(blurTag)) {
                    blurView.removeFromSuperview()
                }
            } else {
                view.viewWithTag(loaderTag)?.removeFromSuperview()
                view.viewWithTag(blurTag)?.removeFromSuperview()
            }
        }
    }
}
