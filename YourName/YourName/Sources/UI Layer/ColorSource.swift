//
//  ColorSource.swift
//  YourName
//
//  Created by Booung on 2021/10/07.
//

import UIKit

enum ColorSource: Equatable {
    case monotone(UIColor)
    case gradient([UIColor])
}
extension ColorSource {
    
    static func from(_ colors: [UIColor]) -> Self? {
        if colors.count > 1 {
            return .gradient(colors)
        } else if let color = colors.first {
            return .monotone(color)
        } else {
            return nil
        }
    }
    
    static func from(_ hexStrings: [String]) -> Self? {
        return self.from(hexStrings.compactMap { UIColor(hexString: $0) })
    }
}
