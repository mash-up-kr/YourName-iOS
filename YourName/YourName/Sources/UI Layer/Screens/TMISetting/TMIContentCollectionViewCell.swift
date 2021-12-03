//
//  TMIContentCollectionViewCell.swift
//  YourName
//
//  Created by Booung on 2021/10/07.
//

import UIKit

struct TMIContentCellViewModel: Equatable {
    let id: Identifier
    var isSelected: Bool
    let content: String
    let imageSource: ImageSource
}

final class TMIContentCollectionViewCell: UICollectionViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.cornerRadius = 12
        self.contentView.clipsToBounds = true
        self.contentView.borderColor = Palette.black1
    }
    
    func configure(with viewModel: TMIContentCellViewModel) {
        self.contentLabel?.text = viewModel.content
        self.contentView.borderWidth = viewModel.isSelected ? 2 : 0
        self.iconImageView?.setImageSource(viewModel.imageSource)
    }
    
    @IBOutlet private weak var iconImageView: UIImageView?
    @IBOutlet private weak var contentLabel: UILabel?
}
