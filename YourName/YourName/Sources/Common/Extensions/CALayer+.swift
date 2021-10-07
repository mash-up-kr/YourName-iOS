//
//  CALayer+.swift
//  YourName
//
//  Created by 송서영 on 2021/10/02.
//

import UIKit

extension CALayer {
    func applyShadow(color: CGColor = UIColor.black.cgColor,
                     alpha: Float = 0.25,
                     x: CGFloat = 0,
                     y: CGFloat = 0,
                     blur: CGFloat = 5) {
        self.shadowColor = color
        self.shadowOpacity = alpha
        self.shadowOffset = CGSize(width: x, height: y)
        self.shadowRadius = blur / 2
    }
}
