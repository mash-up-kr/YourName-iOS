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
        let imageDomain = "https://erme.s3.ap-northeast-2.amazonaws.com"
        switch imageSource {
        case .image(let image):     self.image = image
        case .url(let url):         self.kf.setImage(with: URL(string: "\(imageDomain)/\(url)"))
        case .data(let data):       self.image = UIImage(data: data)
        case .none:                 self.image = nil
        }
    }
}

extension Reactive where Base: UIImageView {
    var imageSource: Binder<ImageSource?> {
        let imageDomain = "https://erme.s3.ap-northeast-2.amazonaws.com"
        return Binder(self.base) { view, imageSource in
            switch imageSource {
            case .image(let image):     view.image = image
            case .url(let url):         view.kf.setImage(with: URL(string: "\(imageDomain)/\(url)"))
            case .data(let data):       view.image = UIImage(data: data)
            case .none:                 view.image = nil
            }
        }
    }
}
