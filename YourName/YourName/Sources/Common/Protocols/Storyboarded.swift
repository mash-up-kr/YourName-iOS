//
//  File.swift
//  YourName
//
//  Created by Booung on 2021/09/30.
//

import UIKit

protocol Storyboarded: UIViewController {
    static func instantiate() -> Self
}
extension Storyboarded {
    static func instantiate() -> Self {
        let storyboardName = String(describing: self)
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        return storyboard.instantiateInitialViewController() as! Self
    }
}
