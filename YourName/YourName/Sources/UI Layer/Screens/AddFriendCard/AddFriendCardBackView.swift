//
//  AddFriendCardBackView.swift
//  MEETU
//
//  Created by seori on 2021/11/06.
//

import UIKit

final class AddFriendCardBackView: NibLoadableView {
    
    struct Item {
        let contacts: [Contact]
        let personality: String
        let introduce: String
        let backgroundColor: UIColor
        
        struct Contact {
            let image: String
            let type: String
            let value: String
        }
    }

    @IBOutlet private unowned var contactStackView: UIStackView!
    @IBOutlet private unowned var personalityLabel: UILabel!
    @IBOutlet private unowned var introduceLabel: UILabel!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFromNib()
        configureUI()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupFromNib()
        configureUI()
    }
}

extension AddFriendCardBackView {
    
    private func configureUI() {
        self.contactStackView.arrangedSubviews.forEach { $0.isHidden = true }
        contentView.layer.cornerRadius = 12
    }
    
    func configure(item: Item) {
        self.personalityLabel.text = item.personality
        self.introduceLabel.text = item.introduce
        self.contentView.backgroundColor = item.backgroundColor
        
        item.contacts.enumerated().forEach { index, contact in
            contactStackView.arrangedSubviews[safe: index]?.isHidden = false
            let boldText = contact.type
            let boldAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 14, weight: .bold)
            ]
            let attributedText = NSMutableAttributedString(string: boldText + contact.value)
            attributedText.setAttributes(boldAttributes, range: NSRange(location: 0, length: boldText.count))
            
            let contactLabel = contactStackView.arrangedSubviews[safe: index]?.subviews[safe: 1] as? UILabel
            contactLabel?.attributedText = attributedText
        }
    }
}
