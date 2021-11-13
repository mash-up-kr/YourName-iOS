//
//  CardBookCollectionViewCell.swift
//  YourName
//
//  Created by seori on 2021/10/03.
//

import UIKit

protocol FriendCardCollectionViewCellDelegate: AnyObject {
    func friendCardCollectionViewCell(didTapCheck indexPath: IndexPath)
}

struct FriendCardCellViewModel {
    let name: String?
    let role: String?
    let bgColor: ColorSource?
    let isEditing: Bool
    let isChecked: Bool
}

final class FriendCardCollectionViewCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.frame = self.contentView.bounds
    }
    
    func configure(with viewModel: FriendCardCellViewModel) {
        self.nameLabel?.text = viewModel.name
        self.roleLabel?.text = viewModel.role
        self.checkBoxView?.isHidden = viewModel.isEditing
        self.checkBoxView?.backgroundColor = viewModel.isChecked ? .black : .white
        guard let colorSource = viewModel.bgColor else { return }
        switch colorSource {
        case .monotone(let color):
            gradientLayer.colors = [color, color]
        case .gradient(let colors):
            gradientLayer.colors = colors
        }
    }
    
    private let gradientLayer = CAGradientLayer()
    
    @IBOutlet private weak var profileImageView: UIImageView?
    @IBOutlet private weak var roleLabel: UILabel?
    @IBOutlet private weak var nameLabel: UILabel?
    @IBOutlet private weak var checkBoxView: UIImageView?
    
}
