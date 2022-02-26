//
//  CardBookCoverTableViewCell.swift
//  MEETU
//
//  Created by USER on 2021/10/29.
//

import UIKit

final class CardBookCoverTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.coverBackgroundView?.clipsToBounds = true
        self.coverImageview?.clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(with cardBook: CardBook) {
        self.titleLabel?.text = cardBook.title
        self.cardCountLabel?.text = "(\(cardBook.count ?? .zero))"
        self.descriptionLabel?.text = cardBook.description
        if let hexStrings = cardBook.backgroundColor {
            self.coverBackgroundView?.updateGradientLayer(hexStrings: hexStrings)
            self.coverImageview?.image = UIImage(named: "ghost_cover")
        } else {
            self.coverImageview?.image = UIImage(named: "card_book_cover_all")
        }
    }
    @IBOutlet private weak var coverBackgroundView: UIView?
    @IBOutlet private weak var coverImageview: UIImageView?
    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var cardCountLabel: UILabel?
    @IBOutlet private weak var descriptionLabel: UILabel?
    
}
