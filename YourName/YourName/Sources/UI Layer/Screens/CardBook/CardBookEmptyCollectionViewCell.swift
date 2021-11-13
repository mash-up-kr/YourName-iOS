//
//  CardBookEmptyCollectionViewCell.swift
//  YourName
//
//  Created by seori on 2021/10/03.
//

import UIKit

final class CardBookEmptyCollectionViewCell: UICollectionViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.cornerRadius = 12
        dashBorder()
    }
}
