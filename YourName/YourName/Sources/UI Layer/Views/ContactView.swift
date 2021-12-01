//
//  ContactView.swift
//  MEETU
//
//  Created by seori on 2021/11/07.
//

import UIKit

final class ContactView: NibLoadableView {
    
    @IBOutlet private unowned var contactIcon: UIImageView!
    @IBOutlet private unowned var contactLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFromNib()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupFromNib()
    }
}

extension ContactView {
    func configure(contact: AddFriendCardBackView.Item.Contact) {
        if let imageURL = URL(string: contact.image) {
            contactIcon.setImageSource(.url(imageURL))
        }
        
        let boldText = contact.type
        let boldAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14, weight: .bold)
        ]
        let attributedText = NSMutableAttributedString(string: boldText + contact.value)
        attributedText.setAttributes(boldAttributes, range: NSRange(location: 0, length: boldText.count))
        self.contactLabel.attributedText = attributedText
    }
}
