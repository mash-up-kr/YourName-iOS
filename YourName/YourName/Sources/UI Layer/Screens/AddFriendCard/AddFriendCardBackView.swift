//
//  AddFriendCardBackView.swift
//  MEETU
//
//  Created by seori on 2021/11/06.
//

import UIKit
import RxSwift

final class AddFriendCardBackView: NibLoadableView {
    
    struct Item {
        let contacts: [Contact]
        let personality: String
        let introduce: String
        let backgroundColor: UIColor
        
        struct Contact {
            let image: String
            let type: String
            let value: String
        }
    }

    @IBOutlet private unowned var flipButton: UIButton!
    @IBOutlet private unowned var contactStackView: UIStackView!
    @IBOutlet private unowned var personalityLabel: UILabel!
    @IBOutlet private unowned var introduceLabel: UILabel!
    
    var didTapFlipButton: ((AddFriendCardResultView.CardState) -> Void)!
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFromNib()
        configureUI()
        bind()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder) 
        setupFromNib()
        configureUI()
        bind()
    }
}

extension AddFriendCardBackView {
    
    private func configureUI() {
        self.contentView.layer.cornerRadius = 12
        self.contactStackView.isLayoutMarginsRelativeArrangement = true
        self.contactStackView.layoutMargins = .init(top: 23, left: 20, bottom: 23, right: 20)
    }
    
    func configure(item: Item) {
        self.contactStackView.arrangedSubviews.forEach { $0.isHidden = true }
        self.personalityLabel.text = item.personality
        self.introduceLabel.text = item.introduce
        self.contentView.backgroundColor = item.backgroundColor
        
        item.contacts.enumerated().forEach { index, contact in
            guard let subView = self.contactStackView.arrangedSubviews[safe: index] as? ContactView else { return }
            subView.isHidden = false
            subView.configure(contact: contact)
        }
    }
    private func bind() {
        self.flipButton.rx.throttleTap
            .bind(onNext: { [weak self] _ in
                self?.didTapFlipButton(.back)
            })
            .disposed(by: disposeBag)
    }
}
