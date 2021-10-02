//
//  MyCardListEmptyCollectionViewCell.swift
//  YourName
//
//  Created by 송서영 on 2021/10/02.
//

import UIKit

final class MyCardListEmptyCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var createMyCardView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .blue
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
}
