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
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(with cardBook: CardBook) {
        self.titleLabel?.text = cardBook.title
        self.cardCountLabel?.text = "(\(cardBook.count ?? .zero))"
        self.descriptionLabel?.text = cardBook.description
        if let hexString = cardBook.backgroundColor {
            self.coverImageview?.backgroundColor = UIColor(hexString: hexString)
            self.coverImageview?.image = UIImage(named: "card_book_logo")
        } else {
            self.coverImageview?.backgroundColor = .white
            self.coverImageview?.image = UIImage(named: "card_book_cover_all")
        }
    }
    
    @IBOutlet private weak var coverImageview: UIImageView?
    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var cardCountLabel: UILabel?
    @IBOutlet private weak var descriptionLabel: UILabel?
}
