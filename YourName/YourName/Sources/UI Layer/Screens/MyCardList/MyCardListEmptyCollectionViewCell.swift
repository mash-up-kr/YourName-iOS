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
    
    @IBOutlet weak var createCardButton: UIButton!
    private(set) var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = .init()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 12
        dashBorder()
    }
}
