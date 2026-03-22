//
//  UIImageViewer.swift
//  Trending Movies
//
//  Created by Abanoob Samy on 12/03/2026.
//

import UIKit

extension ShowImageVC {
    
    func setupUI() {
        movieIv.removeFromSuperview()
        
        view.addSubview(scrollView)
        scrollView.addSubview(movieIv)
        
        movieIv.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // The scroll fills the entire screen
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            // The image fills the entire scroll
            movieIv.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            movieIv.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            movieIv.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            movieIv.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            
            // These are to make the image exactly the size of the screen before zooming
            movieIv.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            movieIv.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor)
        ])
    }
    
    func setupGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreen))
        view.addGestureRecognizer(tap)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        view.addGestureRecognizer(pan)
    }
    
    @objc func dismissFullscreen() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        
        guard scrollView.zoomScale == 1.0 else { return }
            
        let translation = gesture.translation(in: view)
        let dragPercentage = abs(translation.y) / view.bounds.height
        let alpha = 1.0 - dragPercentage * 2.0
        
        switch gesture.state {
        case .changed:
            view.transform = CGAffineTransform(translationX: translation.x, y: translation.y)
                .scaledBy(x: 1.0 - (dragPercentage * 0.2), y: 1.0 - (dragPercentage * 0.2))
            view.backgroundColor = UIColor.black.withAlphaComponent(alpha)
            
        case .ended, .cancelled:
            if abs(translation.y) > 150 || abs(gesture.velocity(in: view).y) > 1000 {
                dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.view.transform = .identity
                    self.view.backgroundColor = .black
                }, completion: nil)
            }
        default:
            break
        }
    }
}

// MARK: - UIScrollViewDelegate
extension ShowImageVC: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return movieIv
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerImage()
    }
}
