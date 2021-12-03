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
        let personality: String?
        let introduce: String?
        let backgroundColor: ColorSource
        
        struct Contact {
            let image: String
            let type: String
            let value: String
        }
    }

    // MARK: - Properties
    @IBOutlet private unowned var personalityHeaderLabel: UILabel!
    @IBOutlet private unowned var contactHeaderLabel: UILabel!
    @IBOutlet private unowned var flipButton: UIButton!
    @IBOutlet private unowned var contactStackView: UIStackView!
    @IBOutlet private unowned var personalityLabel: UILabel!
    @IBOutlet private unowned var introduceLabel: UILabel!
    @IBOutlet private unowned var personalityView: UIStackView!
    @IBOutlet private unowned var personalityStackView: UIStackView!
    @IBOutlet private unowned var personalityViewTopConstraints: NSLayoutConstraint!
    
    var didTapFlipButton: ((AddFriendCardResultView.CardState) -> Void)!
    private let disposeBag = DisposeBag()
    
    // MARK: - Init
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
    
    deinit {
        print("\(String(describing: self)) deinit")
    }
    
    // MARK: - Methods
    func configure(item: Item) {
        self.personalityStackView.arrangedSubviews.forEach { $0.isHidden = true }
        self.contactStackView.arrangedSubviews.forEach { $0.isHidden = true }
        self.contactHeaderLabel.isHidden = false
        self.personalityHeaderLabel.isHidden = false
        self.personalityStackView.isHidden = false
        self.contactStackView.isHidden = false
        self.personalityLabel.isHidden = false
        self.introduceLabel.isHidden = false
        self.personalityLabel.text = ""
        self.introduceLabel.text = ""
        self.personalityViewTopConstraints.constant = 32
        
        switch item.backgroundColor {
        case .gradient(let colors):
            self.contentView.updateGradientLayer(colors: colors)
        case .monotone(let color):
            self.contentView.updateGradientLayer(colors: [color])
        }
        
        if item.contacts.count == 0 {
            self.contactHeaderLabel.isHidden = true
            self.contactStackView.isHidden = true
            self.personalityViewTopConstraints.constant = 0
        }

        item.contacts.enumerated().forEach { index, contact in
            guard let subView = self.contactStackView.arrangedSubviews[safe: index] as? ContactView else { return }
            subView.isHidden = false
            subView.configure(contact: contact)
        }
        
        if item.personality == nil && item.introduce == nil {
            self.personalityHeaderLabel.isHidden = true
            self.personalityStackView.isHidden = true
        }
        if let personality = item.personality {
            self.personalityLabel.text = personality
        }
        if let introduce = item.introduce {
            self.introduceLabel.text = introduce
        }
    }
}

extension AddFriendCardBackView {
    
    private func configureUI() {
        self.contentView.layer.cornerRadius = 12
        self.contentView.layer.masksToBounds = true
        self.contactStackView.isLayoutMarginsRelativeArrangement = true
        self.contactStackView.layoutMargins = .init(top: 23, left: 20, bottom: 23, right: 20)
        self.personalityView.isLayoutMarginsRelativeArrangement = true
        self.personalityView.layoutMargins = .init(top: 23, left: 20, bottom: 23, right: 20)
    }
    
    private func bind() {
        self.flipButton.rx.throttleTap
            .bind(onNext: { [weak self] _ in
                guard let self =  self else { return }
                self.didTapFlipButton(.back)
            })
            .disposed(by: disposeBag)
    }
}
