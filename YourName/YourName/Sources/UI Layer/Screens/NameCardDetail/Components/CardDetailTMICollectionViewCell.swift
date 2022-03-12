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
    
    static func dynamicCellSize(_ tmi: Entity.TMI, height: CGFloat = 40) -> CGSize {
        guard let cell = UINib(nibName: String(describing: self), bundle: nil).instantiate(withOwner: nil, options: nil).first as? Self else { return .zero }
        cell.configure(with: tmi)
        let targetSize = CGSize(
            width: UIView.layoutFittingCompressedSize.width,
            height: height
        )
        return cell.contentView.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .fittingSizeLevel,
            verticalFittingPriority: .required
        )
    }

    @IBOutlet private weak var iconImageView: UIImageView?
    @IBOutlet private weak var contentLabel: UILabel?
}
