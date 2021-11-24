//
//  CardBookCollectionViewCell.swift
//  YourName
//
//  Created by seori on 2021/10/03.
//

import UIKit
import Then

protocol FriendCardCollectionViewCellDelegate: AnyObject {
    func friendCardCollectionViewCell(didTapCheck id: String)
}

struct FriendCardCellViewModel: Equatable, Then {
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
        
        self.clipsToBounds = true
        self.borderWidth = 3
        self.checkBoxView?.clipsToBounds = true
        self.checkBoxView?.borderWidth = 3
    }
    
    func configure(with viewModel: FriendCardCellViewModel) {
        self.nameLabel?.text = viewModel.name
        self.roleLabel?.text = viewModel.role
        self.checkBoxView?.isHidden = viewModel.isEditing == false
        self.checkBoxView?.backgroundColor = viewModel.isChecked ? .black : .white
        guard let colorSource = viewModel.bgColor else { return }
        switch colorSource {
        case .monotone(let color):
            self.backgroundColor = color
        case .gradient(let colors):
            self.backgroundColor = nil
        }
        self.borderColor = viewModel.isChecked ? .black : .clear
    }
    
    @objc
    private func checkBoxDidTap() {
        guard let cardID = self.cardID else { return }
        
        self.delegate?.friendCardCollectionViewCell(didTapCheck: cardID)
    }
    
    private let cardID: String? = nil
    
    @IBOutlet private weak var profileImageView: UIImageView?
    @IBOutlet private weak var roleLabel: UILabel?
    @IBOutlet private weak var nameLabel: UILabel?
    @IBOutlet private weak var checkBoxView: UIImageView?
    
}
