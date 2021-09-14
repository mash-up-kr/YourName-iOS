//
//  UIStackView+.swift
//  YourName
//
//  Created by Booung on 2021/09/12.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach(addArrangedSubview(_:))
    }
}
