//
//  SnapshotUseCase.swift
//  YourName
//
//  Created by Booung on 2021/09/14.
//

import UIKit

protocol SnapshotService {
    static func capture(_ view: UIView) -> Data?
    static func captureImage(_ view: UIView) -> UIImage?
}

enum YourNameSnapshotService: SnapshotService {
    static func capture(_ view: UIView) -> Data? {
        let renderer = UIGraphicsImageRenderer(bounds: view.bounds)
        return renderer.image { rendererContext in
            view.layer.render(in: rendererContext.cgContext)
        }.jpegData(compressionQuality: 0)
    }
    static func captureImage(_ view: UIView) -> UIImage? {
        let render = UIGraphicsImageRenderer(bounds: view.bounds)
        let image = render.image { _ in
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }
        return image
    }
}
