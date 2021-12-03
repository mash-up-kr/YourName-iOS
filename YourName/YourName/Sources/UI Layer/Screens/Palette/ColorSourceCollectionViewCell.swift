//
//  ColorCollectionViewCell.swift
//  YourName
//
//  Created by Booung on 2021/10/03.
//

import UIKit

enum ColorSourceStatus: Equatable {
    case normal
    case selected
    case locked
}

final class ColorSourceCollectionViewCell: UICollectionViewCell {
    
    private var colorSource: ColorSource = .monotone(Palette.lightGray1)
    private var status: ColorSourceStatus = .normal
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.contentView.clipsToBounds = true
        self.contentView.cornerRadius = 10
        self.colorLayer.frame = self.contentView.bounds
        self.colorLayer.startPoint = .zero
        self.colorLayer.endPoint = CGPoint(x: 1, y: 1)
        self.contentView.layer.insertSublayer(colorLayer, at: 0)
    }
    
    func configure(profileColor: YourNameColor) {
        self.colorSource = profileColor.colorSource
        self.status = profileColor.status

        self.configure(with: colorSource)
        self.configure(with: status)
    }
    
    private func configure(with color: ColorSource) {
        let isLockedColor = status == .locked
        
        switch colorSource {
        case .monotone(let color):
            self.contentView.backgroundColor = color.withAlphaComponent(isLockedColor ? 0.6 : 1)
            colorLayer.colors = nil
        case .gradient(let colors):
            self.contentView.backgroundColor = nil
            colorLayer.colors = colors.compactMap { $0.cgColor.copy(alpha: isLockedColor ? 0.6 : 1) }
        }
    }
    
    private func configure(with status: ColorSourceStatus) {
        switch status {
        case .normal:
            self.contentView.borderWidth = 0
            iconImageView?.image = nil
            
        case .selected:
            self.contentView.borderWidth = 3
            iconImageView?.image = UIImage(named: "icon_check")
            
        case .locked:
            self.contentView.borderWidth = 0
            iconImageView?.image = UIImage(named: "icon_lock")
        }
    }
    
    private let colorLayer: CAGradientLayer = CAGradientLayer()
    @IBOutlet private weak var iconImageView: UIImageView?
}
