//
//  ColorCollectionViewCell.swift
//  YourName
//
//  Created by Booung on 2021/10/03.
//

import UIKit

enum ColorSourceStatus {
    case normal
    case selected
    case locked
}

final class ColorSourceCollectionViewCell: UICollectionViewCell {
    
    private var colorSource: ColorSource = .monotone(Palette.lightGray1)
    private var status: ColorSourceStatus = .normal
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(profileColor: ProfileColor) {
        self.colorSource = profileColor.colorSource
        self.status = profileColor.status
        
        updateUI(with: colorSource)
        updateUI(with: status)
    }
    
    private func updateUI(with color: ColorSource) {
        let isLockedColor = status == .locked
        
        switch colorSource {
        case .monotone(let color):
            backgroundColor = color.withAlphaComponent(isLockedColor ? 0.6 : 1)
            colorLayer.colors = nil
        case .gradient(let colors):
            backgroundColor = nil
            colorLayer.colors = colors.compactMap{ $0.cgColor.copy(alpha: isLockedColor ? 0.6 : 1) }
        }
    }
    
    private func updateUI(with status: ColorSourceStatus) {
        switch status {
        case .normal:
            borderWidth = 0
            iconImageView?.image = nil
            
        case .selected:
            borderWidth = 3
            iconImageView?.image = UIImage(named: "icon_check")
            
        case .locked:
            borderWidth = 0
            iconImageView?.image = UIImage(named: "icon_lock")
        }
    }
    
    private let colorLayer: CAGradientLayer = CAGradientLayer()
    @IBOutlet private weak var iconImageView: UIImageView?
}
