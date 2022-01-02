//
//  SnapshotUseCase.swift
//  YourName
//
//  Created by Booung on 2021/09/14.
//

import UIKit
import SnapKit

protocol SnapshotService {
    static func capture(_ view: UIView) -> Data?
    static func captureToImage(_ scrollView: UIScrollView) -> UIImage?
}

enum YourNameSnapshotService: SnapshotService {
    static func capture(_ view: UIView) -> Data? {
        let renderer = UIGraphicsImageRenderer(bounds: view.bounds)
        return renderer.image { rendererContext in
            view.layer.render(in: rendererContext.cgContext)
        }.jpegData(compressionQuality: 0)
    }
    
    static func captureToImage(_ scrollView: UIScrollView) -> UIImage? {
        // saved scrollView info
        let savedFrame = scrollView.frame
        let savedOffset = scrollView.contentOffset
        let superview = scrollView.superview
        
        // remove from superView
        scrollView.removeFromSuperview()
        
        // UIImage render
        let renderer = UIGraphicsImageRenderer(size: scrollView.contentSize)
        let image = renderer.image { [weak scrollView] context in
            guard let scrollView = scrollView else { return }
            scrollView.frame = CGRect(x: 0, y: 0,
                                      width: scrollView.contentSize.width,
                                      height: scrollView.contentSize.height)
            scrollView.layer.render(in: context.cgContext)
        }
        
        // add subview & configure scrollView
        superview?.addSubview(scrollView)
        superview?.layoutIfNeeded()
        scrollView.snp.makeConstraints { $0.edges.equalToSuperview() }
        scrollView.frame = savedFrame
        scrollView.contentOffset = savedOffset
    
        return image
    }
}
