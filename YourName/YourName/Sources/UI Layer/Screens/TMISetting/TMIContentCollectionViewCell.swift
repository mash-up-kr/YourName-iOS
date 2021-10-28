//
//  TMIContentCollectionViewCell.swift
//  YourName
//
//  Created by Booung on 2021/10/07.
//

import UIKit

struct TMIContentCellViewModel: Equatable {
    var isSelected: Bool
    let content: String
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
    }
    
    @IBOutlet private weak var contentLabel: UILabel?
}
