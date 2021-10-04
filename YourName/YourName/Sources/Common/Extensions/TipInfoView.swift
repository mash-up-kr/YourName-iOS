//
//  TipView.swift
//  YourName
//
//  Created by Booung on 2021/10/04.
//

import UIKit

final class TipInfoView: UIView, NibLoadable {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupFromNib()
    }
    
    @IBOutlet private weak var infoLabel: UILabel?
}
extension TipInfoView {
    @IBInspectable
    var text: String? {
        get { infoLabel?.text }
        set { infoLabel?.text = newValue }
    }
    @IBInspectable
    var attributeText: NSAttributedString? {
        get { infoLabel?.attributedText }
        set { infoLabel?.attributedText = newValue }
    }
}
