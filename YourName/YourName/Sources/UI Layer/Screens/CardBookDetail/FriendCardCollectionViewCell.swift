//
//  CardBookCollectionViewCell.swift
//  YourName
//
//  Created by seori on 2021/10/03.
//

import UIKit

protocol FriendCardCollectionViewCellDelegate: AnyObject {
    func friendCardCollectionViewCell(didTapCheck id: String)
}

struct FriendCardCellViewModel: Equatable {
    let id: String?
    let name: String?
    let role: String?
    let bgColor: ColorSource?
    var isEditing: Bool
    var isChecked: Bool
}

final class FriendCardCollectionViewCell: UICollectionViewCell {

    weak var delegate: FriendCardCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(checkBoxDidTap))
        self.checkBoxView?.addGestureRecognizer(tapGesture)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.contentView.borderColor = .clear
        self.contentView.borderWidth = 3
    }
    
    func configure(with viewModel: FriendCardCellViewModel) {
        self.nameLabel?.text = viewModel.name
        self.roleLabel?.text = viewModel.role
        self.checkBoxView?.isHidden = viewModel.isEditing
        self.checkBoxView?.backgroundColor = viewModel.isChecked ? .black : .white
        self.contentView.borderColor = viewModel.isChecked ? .black : .white
        guard let colorSource = viewModel.bgColor else { return }
        switch colorSource {
        case .monotone(let color):
//            self.contentView.backgroundColor = color
            self.contentView.backgroundColor = nil
            gradientLayer.colors = [color, color]
        case .gradient(let colors):
            self.contentView.backgroundColor = nil
            gradientLayer.colors = colors
        }
        self.gradientLayer.frame = self.contentView.bounds
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    @objc
    private func checkBoxDidTap() {
        guard let cardID = self.cardID else { return }
        
        self.delegate?.friendCardCollectionViewCell(didTapCheck: cardID)
    }
    
    private let cardID: String? = nil
    private let gradientLayer = CAGradientLayer()
    
    @IBOutlet private weak var profileImageView: UIImageView?
    @IBOutlet private weak var roleLabel: UILabel?
    @IBOutlet private weak var nameLabel: UILabel?
    @IBOutlet private weak var checkBoxView: UIImageView?
    
}
