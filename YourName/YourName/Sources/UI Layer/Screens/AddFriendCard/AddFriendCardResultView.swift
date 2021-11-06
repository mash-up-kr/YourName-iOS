//
//  AddFriendCardResultView.swift
//  MEETU
//
//  Created by seori on 2021/11/06.
//

import UIKit

final class AddFriendCardResultView: UIView, NibLoadable {
    
    @IBOutlet private unowned var cardView: MyCardView!
    @IBOutlet private unowned var flipButton: UIButton!
    @IBOutlet private unowned var addButton: UIButton!
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFromNib()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupFromNib()
    }
}

// MARK: - Methods
extension AddFriendCardResultView {
    func configureCardView(item: MyCardView.Item) {
        self.cardView.configure(item: item)
    }
}
