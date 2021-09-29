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
    
    class func fromNib() -> Self? {
        let nibName = String(describing: self)
        let views = Bundle.main.loadNibNamed(nibName, owner: nil, options: nil)
        return views?.first as? Self
    }
}
