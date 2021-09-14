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
}
