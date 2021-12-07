//
//  CardDetailContactTableViewCell.swift
//  MEETU
//
//  Created by Booung on 2021/12/07.
//

import UIKit

final class CardDetailContactTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with contact: Entity.Contact) {
        if let category = contact.category {
            self.contactCategoryLabel?.text = category.rawValue
        }
        if let value = contact.value {
            self.contactValueLabel?.text = value
        }
        if let urlString = contact.iconURL, let url = URL(string: urlString) {
            self.contactImageView?.setImageSource(.url(url))
        }
    }
    
    @IBOutlet private weak var contactImageView: UIImageView?
    @IBOutlet private weak var contactCategoryLabel: UILabel?
    @IBOutlet private weak var contactValueLabel: UILabel?
}
