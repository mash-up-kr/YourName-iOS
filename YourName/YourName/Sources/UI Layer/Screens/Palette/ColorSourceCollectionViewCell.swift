//
//  ColorCollectionViewCell.swift
//  YourName
//
//  Created by Booung on 2021/10/03.
//

import UIKit


final class ColorSourceCollectionViewCell: UICollectionViewCell {
    
    enum Status {
        case normal
        case selected
        case locked
    }
    
    private var colorSource: ColorSource = .monotone(Palette.lightGray1)
    private var status: Status = .normal
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(colorSource: ColorSource, status: Status) {
        self.colorSource = colorSource
        self.status = status
        
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
    
    private func updateUI(with status: Status) {
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
