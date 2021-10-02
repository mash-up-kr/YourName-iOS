//
//  PaletteView.swift
//  YourName
//
//  Created by Booung on 2021/10/03.
//

import UIKit

final class PaletteView: UIView, NibLoadable {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupFromNib()
    }
    
    @IBOutlet private weak var colorsCollectionView: UICollectionView?
    @IBOutlet private weak var completeButton: UIButton?
}
