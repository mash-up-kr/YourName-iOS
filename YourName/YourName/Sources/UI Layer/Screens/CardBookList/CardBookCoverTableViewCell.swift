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
        
        self.coverImageContainerView?.clipsToBounds = true
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
            self.updateBackgroundColor(colors)
            self.coverImageview?.image = UIImage(named: "ghost_cover")
        } else {
            self.coverImageview?.image = UIImage(named: "card_book_cover_all")
        }
    }
    
    private func updateBackgroundColor(_ colors: [UIColor]) {
        if colors.count > 1 {
            self.coverImageContainerView?.removeGradientLayer(name: Self.gradientLayerKey)
            let gradientLayer = CAGradientLayer().then {
                $0.name = Self.gradientLayerKey
                $0.startPoint = .zero
                $0.endPoint = CGPoint(x: 1, y: 1)
                $0.colors = colors.map { $0.cgColor }
                $0.frame = coverImageview?.bounds ?? .zero
            }
            self.coverImageContainerView?.layer.insertSublayer(gradientLayer, at: 0)
        } else {
            self.coverImageContainerView?.removeGradientLayer(name: Self.gradientLayerKey)
            let gradientLayer = CAGradientLayer().then {
                $0.name = Self.gradientLayerKey
                $0.startPoint = .zero
                $0.endPoint = CGPoint(x: 1, y: 1)
                $0.colors = (colors + colors).map { $0.cgColor }
                $0.frame = coverImageview?.bounds ?? .zero
            }
            self.coverImageContainerView?.layer.insertSublayer(gradientLayer, at: 0)
        }
    }
    
    private static let gradientLayerKey = "gradientLayer"
    private let gradientLayer = CAGradientLayer()
    
    @IBOutlet private weak var coverImageContainerView: UIStackView?
    @IBOutlet private weak var coverImageview: UIImageView?
    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var cardCountLabel: UILabel?
    @IBOutlet private weak var descriptionLabel: UILabel?
    
}
