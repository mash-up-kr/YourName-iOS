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
    
//    @IBOutlet private unowned var createCardButton: UIButton!
    private let disposeBag = DisposeBag()
    var didSelect: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bind()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 12
        dashBorder()
    }
    
    private func bind() {
//        createCardButton.rx.throttleTap
//            .bind(onNext: { [weak self] in
//                guard let self = self,
//                      let didSelect = self.didSelect else { return }
//                didSelect()
//            })
//            .disposed(by: disposeBag)
    }
}
