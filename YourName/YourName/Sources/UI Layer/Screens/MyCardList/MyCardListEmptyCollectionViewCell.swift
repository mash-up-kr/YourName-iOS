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
    
    @IBOutlet private weak var createCardButton: UIButton!
    private let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bind()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 12
        dashBorder()
    }
    
    private func bind() {
        createCardButton.rx.tap
            .throttle(
                .milliseconds(400),
                latest: false,
                scheduler: MainScheduler.instance
            )
            .bind {
                #warning("⚠️ TODO: 삭제") // 송서영
                print("button tapped")
            }
            .disposed(by: disposeBag)
    }
    
}
