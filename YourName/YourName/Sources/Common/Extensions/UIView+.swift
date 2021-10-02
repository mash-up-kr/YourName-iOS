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
    
    class func fromNib<View: UIView>() -> View? {
        let nibName = String(describing: self)
        let views = Bundle.main.loadNibNamed(nibName, owner: nil, options: nil)
        return views?.first as? View
    }
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
            print(cornerRadius, "radius > 0")
            dashBorder.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        } else {
            print(cornerRadius, "==0")
            dashBorder.path = UIBezierPath(rect: bounds).cgPath
        }
        layer.addSublayer(dashBorder)
    }
}

extension UIView {
    
}
