//
//  AddFriendCardNoResultView.swift
//  MEETU
//
//  Created by seori on 2021/11/06.
//

import UIKit

final class AddFriendCardNoResultView: UIView, NibLoadable {
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFromNib()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupFromNib()
    }
    
    deinit {
        print(" 💀 \(String(describing: self)) deinit")
    }
}
