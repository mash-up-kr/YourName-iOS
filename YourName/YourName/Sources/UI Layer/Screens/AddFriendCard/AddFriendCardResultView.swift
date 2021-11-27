//
//  AddFriendCardResultView.swift
//  MEETU
//
//  Created by seori on 2021/11/06.
//

import UIKit
import RxSwift
import RxCocoa

final class AddFriendCardResultView: UIView, NibLoadable {
    
    typealias FrontCardItem = CardFrontView.Item
    typealias BackCardItem = AddFriendCardBackView.Item
    typealias FriendCardState = AddFriendCardViewModel.FriendCardState
    
    enum CardState {
        case front
        case back
    }
    
    @IBOutlet private unowned var cardFrontView: CardFrontView!
    @IBOutlet private unowned var cardBackView: AddFriendCardBackView!
    @IBOutlet private unowned var addButton: UIButton!
    
    private let viewModel = AddFriendCardResultViewModel()
    private let disposeBag = DisposeBag()
    var didTapAddButton: (() -> Void)!
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFromNib()
        bind()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupFromNib()
        bind()
    }
}

// MARK: - Methods

extension AddFriendCardResultView {
    func configure(frontCardItem: FrontCardItem,
                   backCardItem: BackCardItem,
                   friendCardState: FriendCardState,
                   didTapAddButton: @escaping (() -> Void)) {
        self.configureCardView(frontCardItem: frontCardItem,
                               backCardItem: backCardItem)
        self.configureButton(friendCardState)
        self.didTapAddButton = didTapAddButton
    }
    
    private func configureCardView(frontCardItem: FrontCardItem,
                                   backCardItem: BackCardItem) {
        let didTapFlipButton: ((CardState) -> Void) = { state in
            switch state {
            case .front:
                self.cardFrontView.isHidden = true
                self.cardBackView.isHidden = false
            case .back:
                self.cardFrontView.isHidden = false
                self.cardBackView.isHidden = true
            }
        }
        
        self.cardFrontView.configure(item: frontCardItem)
        self.cardFrontView.setupFlipButton(didTap: didTapFlipButton)
        self.cardBackView.configure(item: backCardItem)
        self.cardBackView.didTapFlipButton = didTapFlipButton
    }
    
    private func configureButton(_ state: FriendCardState) {
        switch state {
        case .isAdded:
            self.addButton.backgroundColor = Palette.gray1
            self.addButton.isEnabled = false
        default:
            self.addButton.backgroundColor = Palette.black1
            self.addButton.isEnabled = true
        }
    }
    
    private func bind() {
        self.addButton.rx.throttleTap
            .bind(onNext: { [weak self] _ in
                self?.didTapAddButton()
            })
            .disposed(by: disposeBag)
    }
}
