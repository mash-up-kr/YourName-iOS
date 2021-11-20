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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.frame = coverImageview?.bounds ?? .zero
        gradientLayer.startPoint = .zero
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        coverImageview?.layer.insertSublayer(gradientLayer, at: 0)
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
            let colors = hexStrings.compactMap { UIColor(hexString: $0) }
//            if colors.count > 1 { gradientLayer.colors = colors }
//            else { gradientLayer.colors = colors + colors }
            self.coverImageview?.backgroundColor = colors.first
            self.coverImageview?.image = UIImage(named: "ghost_cover")
        } else {
            self.coverImageview?.backgroundColor = .white
            self.coverImageview?.image = UIImage(named: "card_book_cover_all")
        }
    }
    
    private let gradientLayer = CAGradientLayer()
    
    @IBOutlet private weak var coverImageview: UIImageView?
    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var cardCountLabel: UILabel?
    @IBOutlet private weak var descriptionLabel: UILabel?
    
}
