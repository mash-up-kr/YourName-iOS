//
//  CardBookCoverBackgroundColorCell.swift
//  MEETU
//
//  Created by Seori on 2022/02/10.
//

import UIKit

final class CardBookCoverBackgroundColorCell: UICollectionViewCell {
    
    struct Item: Equatable {
        let id: Identifier
        let isLocked: Bool
        let bgColor: [UIColor]
        var isSelected: Bool = false
        
        mutating func update(isSelected value: Bool) {
            self.isSelected = value
        }
    }

    @IBOutlet private weak var lockImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()

        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.lockImage.isHidden = true
        self.layer.borderWidth = 0
    }
    
    func configure(_ item : Item) {
        self.lockImage.isHidden = !item.isLocked
        self.updateGradientLayer(colors: item.bgColor)
        if item.isSelected {
            self.layer.borderWidth = 3
            self.layer.borderColor = UIColor.black.cgColor
        } else {
            self.layer.borderWidth = 0
        }
    }
}
