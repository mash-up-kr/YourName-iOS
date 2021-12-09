//
//  UIView+.swift
//  YourName
//
//  Created by Booung on 2021/09/12.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach(addSubview(_:))
    }
    
    class func fromNib() -> UIView? {
        let nibName = String(describing: self)
        let views = Bundle.main.loadNibNamed(nibName, owner: nil, options: nil)
        return views?.first as? UIView
    }
    
    private func removeGradientLayer(name: String) {
        self.layer.sublayers?
            .filter { $0 is CAGradientLayer && $0.name == name }
            .forEach { $0.removeFromSuperlayer() }
    }
    
    func setColorSource(_ colorSource: ColorSource) {
        switch colorSource {
        case .monotone(let color):
            self.updateGradientLayer(colors: [color])
        case .gradient(let colors):
            self.updateGradientLayer(colors: colors)
        }
    }
    
    func updateGradientLayer(hexStrings: [String], name: String = UIView.gradientKey) {
        let colors = hexStrings.compactMap { UIColor(hexString: $0) }
        self.updateGradientLayer(colors: colors)
    }
    
    func updateGradientLayer(colors: [UIColor], name: String = UIView.gradientKey) {
        guard colors.isNotEmpty else { return }
        
        self.removeGradientLayer(name: name)
        
        var gradientColors = colors
        if gradientColors.count == 1 {
            gradientColors.append(contentsOf: colors)
        }
        let gradientLayer = CAGradientLayer().then {
            $0.startPoint = .zero
            $0.endPoint = CGPoint(x: 1, y: 1)
            $0.name = name
            
            if let scrollView = self as? UIScrollView {
                $0.frame = CGRect(x: 0, y: 0,
                                  width: scrollView.contentSize.width,
                                  height: scrollView.contentSize.height)
            } else {
                $0.frame = self.bounds
            }
           
            $0.colors = gradientColors.map { $0.cgColor }
        }
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private static let gradientKey = "gradientLayerKey"
   
}
extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get { self.layer.cornerRadius }
        set { self.layer.cornerRadius = newValue }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get { self.layer.borderWidth }
        set { self.layer.borderWidth = newValue }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            guard let cgColor = self.layer.borderColor else { return nil }
            return UIColor(cgColor: cgColor)
        }
        set { self.layer.borderColor = newValue?.cgColor }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get { self.layer.shadowOpacity }
        set { self.layer.shadowOpacity = newValue }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get { self.layer.shadowRadius }
        set { self.layer.shadowRadius = newValue }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get { self.layer.shadowOffset }
        set { self.layer.shadowOffset = newValue }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            guard let cgColor = self.layer.shadowColor else { return nil }
            return UIColor(cgColor: cgColor)
        }
        set { self.layer.shadowColor = newValue?.cgColor }
    }
}

extension UIView {
    func dashBorder(dashWidth: CGFloat = 1,
                    dashColor: CGColor = Palette.gray2.cgColor,
                    dashLength: NSNumber = 4,
                    betweenDashSpace: NSNumber = 4) {
        
        let dashBorder = CAShapeLayer()
        dashBorder.lineWidth = dashWidth
        dashBorder.strokeColor = dashColor
        dashBorder.lineDashPattern = [dashLength, betweenDashSpace]
        dashBorder.frame = bounds
        dashBorder.fillColor = nil
        if cornerRadius > 0 {
            dashBorder.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        } else {
            dashBorder.path = UIBezierPath(rect: bounds).cgPath
        }
        layer.addSublayer(dashBorder)
    }
}
