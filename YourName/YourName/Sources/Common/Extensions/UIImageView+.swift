//
//  UIImageView+.swift
//  YourName
//
//  Created by Booung on 2021/10/02.
//


import Kingfisher
import RxCocoa
import RxSwift
import UIKit

extension UIImageView {
    func setImageSource(_ imageSource: ImageSource?) {
        switch imageSource {
        case .image(let image): self.image = image
        case .url(let url): self.kf.setImage(with: url)
        case .none: self.image = nil
        }
    }
}

extension Reactive where Base: UIImageView {
    var imageSource: Binder<ImageSource?> {
        return Binder(self.base) { view, imageSource in
            switch imageSource {
            case .image(let image): view.image = image
            case .url(let url): view.kf.setImage(with: url)
            case .none: view.image = nil
            }
        }
    }
}
