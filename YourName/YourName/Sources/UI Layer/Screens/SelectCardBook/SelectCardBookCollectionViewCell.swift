//
//  SelectCardBookCollectionViewCell.swift
//  MEETU
//
//  Created by seori on 2021/11/13.
//

import UIKit
import RxSwift
import RxCocoa

final class SelectCardBookCollectionViewCell: UICollectionViewCell {
    
    struct Item {
        let name: String
        let count: Int
        let backgroundColor: UIColor
    }
    
    @IBOutlet private unowned var cardBookCount: UILabel!
    @IBOutlet private unowned var cardBookName: UILabel!
    @IBOutlet private unowned var cardbookIconView: UIView!
    @IBOutlet private unowned var checkView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cardBookName.text = nil
        cardBookCount.text = nil
    }
    
    func bind(item: Item) {
        self.cardBookCount.text = "(\(item.count))"
        self.cardBookName.text = item.name
        self.cardbookIconView.backgroundColor = item.backgroundColor
    }
}

extension SelectCardBookCollectionViewCell {
    private func configureUI() {
        self.checkView.layer.borderWidth = 2
        self.checkView.layer.borderColor = Palette.black1.cgColor
    }
}
