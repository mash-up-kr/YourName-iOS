//
//  MyCardListEmptyCollectionViewCell.swift
//  YourName
//
//  Created by 송서영 on 2021/10/02.
//

import UIKit
import RxSwift
import RxCocoa

final class MyCardListEmptyCollectionViewCell: UICollectionViewCell {
    
    private let disposeBag = DisposeBag()
    var didSelect: (() -> Void) = {}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bind()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dashBorder()
    }
    
    private func bind() {
        self.contentView.rx.tapWhenRecognized
            .bind(onNext: { [weak self]  in
                self?.didSelect()
            })
            .disposed(by: disposeBag)
    }
}
