//
//  SnapshotUseCase.swift
//  YourName
//
//  Created by Booung on 2021/09/14.
//

import UIKit

protocol SnapshotService {
    static func capture(_ view: UIView) -> UIImage
}

enum SnapshotServiceImpl: SnapshotService {
    static func capture(_ view: UIView) -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: view.bounds)
        return renderer.image { rendererContext in
            view.layer.render(in: rendererContext.cgContext)
        }
    }
}
