//
//  CircularRatingView.swift
//  RecipeStream
//
//  Created by Abanoob Samy on 16/03/2026.
//

import UIKit

class CircularRatingView: UIView {
    
    var rating: CGFloat = 65 {
        didSet { setNeedsDisplay() }
    }

    var trackColor: UIColor = UIColor.darkGray.withAlphaComponent(0.5) {
        didSet { setNeedsDisplay() }
    }

    var progressColor: UIColor = .systemGreen {
        didSet { setNeedsDisplay() }
    }

    var insideColor: UIColor = UIColor(red: 8/255, green: 28/255, blue: 34/255, alpha: 1.0) {
        didSet { setNeedsDisplay() }
    }

    var lineWidth: CGFloat = 4 {
        didSet { setNeedsDisplay() }
    }
    
    override func draw(_ rect: CGRect) {
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        let radius = (min(rect.width, rect.height) - lineWidth) / 2
        
        let bgPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        insideColor.setFill()
        bgPath.fill()
        
        let trackPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        trackPath.lineWidth = lineWidth
        trackColor.setStroke()
        trackPath.stroke()
        
        let startAngle: CGFloat = -.pi / 2
        let endAngle: CGFloat = startAngle + (2 * .pi * (rating / 100))
        let progressPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        progressPath.lineWidth = lineWidth
        progressPath.lineCapStyle = .round
        progressColor.setStroke()
        progressPath.stroke()
    }
    
    func configure(with voteAverage: Double) {

        let percentage = CGFloat(voteAverage * 10)
        self.rating = percentage
        
        switch percentage {
        case 70...100:
            // أخضر
            progressColor = UIColor(red: 33/255, green: 208/255, blue: 116/255, alpha: 1.0)
        case 40..<70:
            // أصفر
            progressColor = UIColor(red: 210/255, green: 213/255, blue: 49/255, alpha: 1.0)
        case 1..<40:
            // أحمر
            progressColor = UIColor(red: 219/255, green: 35/255, blue: 96/255, alpha: 1.0)
        default:
            progressColor = .lightGray
        }
        
        trackColor = progressColor.withAlphaComponent(0.3)
    }
}
