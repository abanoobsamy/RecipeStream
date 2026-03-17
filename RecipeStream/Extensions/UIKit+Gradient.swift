import UIKit
import QuartzCore

private let gradientLayerName = "com.recipestream.gradientLayer"

public extension UIView {
    /// Adds or updates a gradient background on the view.
    /// - Parameters:
    ///   - colors: The gradient colors in draw order (top->bottom by default).
    ///   - locations: Optional color stop locations (0...1). If nil, evenly spaced.
    ///   - startPoint: Unit coordinate for gradient start (default top).
    ///   - endPoint: Unit coordinate for gradient end (default bottom).
    func setupGradient(colors: [UIColor],
                       locations: [NSNumber]? = nil,
                       startPoint: CGPoint = CGPoint(x: 0.5, y: 0.0),
                       endPoint: CGPoint = CGPoint(x: 0.5, y: 1.0)) {
        // Remove any existing gradient layer we previously added to avoid stacking
        removeExistingGradientLayerIfNeeded()

        let gradient = CAGradientLayer()
        gradient.name = gradientLayerName
        gradient.colors = colors.map { $0.cgColor }
        gradient.locations = locations
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        gradient.frame = bounds
        layer.insertSublayer(gradient, at: 0)
    }

    /// Call from layoutSubviews to keep the gradient sized with the view.
    func updateGradientFrameIfNeeded() {
        guard let gradient = layer.sublayers?.first(where: { $0.name == gradientLayerName }) as? CAGradientLayer else { return }
        if gradient.frame != bounds { gradient.frame = bounds }
    }

    private func removeExistingGradientLayerIfNeeded() {
        layer.sublayers?.removeAll(where: { $0.name == gradientLayerName })
    }
}
