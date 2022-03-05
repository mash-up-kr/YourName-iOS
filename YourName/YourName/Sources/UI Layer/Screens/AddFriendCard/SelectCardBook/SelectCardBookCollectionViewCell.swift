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
        let id: Identifier
        let name: String
        let count: Int
        let bgColorHexString: [String]
        var isChecked: Bool = false
    }
    
    var checkboxDidTap: ((Bool) -> Void)!
    private var isChecked: Bool = false
    @IBOutlet private unowned var cardBookCount: UILabel!
    @IBOutlet private unowned var cardBookName: UILabel!
    @IBOutlet private unowned var cardbookIconView: UIView!
    @IBOutlet private unowned var checkbox: UIView!

    private let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.configureUI()
        self.bind()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.cardBookName.text = nil
        self.cardBookCount.text = nil
        self.checkbox.backgroundColor = .white
        self.isChecked = false
        self.cardbookIconView.updateGradientLayer(colors: [.white])
    }
    
    func configure(item: Item) {
        self.isChecked = item.isChecked
        self.cardBookCount.text = "(\(item.count))"
        self.cardBookName.text = item.name
        self.cardbookIconView.updateGradientLayer(hexStrings: item.bgColorHexString)
    }
}

extension SelectCardBookCollectionViewCell {
    private func configureUI() {
        self.checkbox.layer.borderWidth = 2
        self.checkbox.layer.borderColor = Palette.black1.cgColor
        self.cardbookIconView.clipsToBounds = true
    }
    
    private func bind() {
        self.checkbox.rx.tapWhenRecognized
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                self.isChecked.toggle()
                self.checkboxDidTap(self.isChecked)
                if self.isChecked {
                    self.checkbox.backgroundColor = Palette.black1
                } else {
                    self.checkbox.backgroundColor = .white
                }
            })
            .disposed(by: disposeBag)
    }
}
