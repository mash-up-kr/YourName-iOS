//
//  ItemCategoryCollectionViewCell.swift
//  YourName
//
//  Created by Booung on 2021/10/06.
//

import UIKit

class ItemCategoryCollectionViewCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with category: ItemCategory, isSelected: Bool) {
        self.categoryNameLabel?.text = category.description
        if isSelected {
            self.focusLineView?.isHidden = false
            categoryNameLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            categoryNameLabel?.textColor = Palette.black1
        } else {
            self.focusLineView?.isHidden = true
            categoryNameLabel?.font = UIFont.systemFont(ofSize: 16)
            categoryNameLabel?.textColor = Palette.gray2
        }
    }

    @IBOutlet private weak var focusLineView: UIView?
    @IBOutlet private weak var categoryNameLabel: UILabel?
}
