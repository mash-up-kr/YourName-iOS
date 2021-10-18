//
//  DisplayCharacterItemCollectionViewCell.swift
//  YourName
//
//  Created by Booung on 2021/10/06.
//

import UIKit

final class DisplayCharacterItemCollectionViewCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(with item: CharacterItem) {
        displayItemImageView?.image = UIImage(named: item.displayItemID)
    }
    
    @IBOutlet private weak var displayItemImageView: UIImageView?
}
