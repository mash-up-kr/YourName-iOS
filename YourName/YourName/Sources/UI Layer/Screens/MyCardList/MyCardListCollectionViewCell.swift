//
//  MyCardListCollectionViewCell.swift
//  YourName
//
//  Created by seori on 2021/10/02.
//

import UIKit

final class MyCardListCollectionViewCell: UICollectionViewCell {

    override func prepareForReuse() {
        super.prepareForReuse()
        guard let myCard = self.contentView as? CardFrontView else { return }
        
        myCard.userNameLabel.text = nil
        myCard.userProfileImage.image = nil
        myCard.userRoleLabel.text = nil
    }
}
