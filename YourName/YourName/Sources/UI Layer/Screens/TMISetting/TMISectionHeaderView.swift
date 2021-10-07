//
//  TMISectionHeaderView.swift
//  YourName
//
//  Created by Booung on 2021/10/07.
//

import UIKit

final class TMISectionHeaderView: UICollectionReusableView {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(title: String) {
        titleLabel?.text = title
    }
    
    @IBOutlet private weak var titleLabel: UILabel?
    
}
