//
//  CardDetailTMICollectionViewCell.swift
//  MEETU
//
//  Created by Booung on 2021/12/07.
//

import UIKit

final class CardDetailTMICollectionViewCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with tmi: Entity.TMI) {
        if let urlString = tmi.iconURL, let url = URL(string: urlString) {
            self.iconImageView?.setImageSource(.url(url))
        }
        if let value = tmi.name {
            self.contentLabel?.text = value
        }
    }

    @IBOutlet private weak var iconImageView: UIImageView?
    @IBOutlet private weak var contentLabel: UILabel?
}
