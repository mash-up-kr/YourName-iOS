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
    
    private let viewModel = AddFriendCardResultViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupFromNib()
    }
}

// MARK: - Methods

extension AddFriendCardResultView {
    func configure(frontCardItem: FrontCardItem,
                   backCardItem: BackCardItem,
                   friendCardState: FriendCardState) {
        self.configureCardView(frontCardItem: frontCardItem,
                               backCardItem: backCardItem)
    }
    
    private func configureCardView(frontCardItem: FrontCardItem,
                                   backCardItem: BackCardItem) {
        self.cardFrontView.configure(item: frontCardItem)
        self.cardFrontView.setupFlipButton(didTapFlipButton: self.didTapFlipButton(state:))
        self.cardBackView.configure(item: backCardItem)
        self.cardBackView.didTapFlipButton = self.didTapFlipButton(state:)
        
    }
    
    private func didTapFlipButton(state: CardState) {
        switch state {
        case .front:
            UIView.transition(from: self.cardFrontView, to: self.cardBackView,
                              duration: 0.5, options: [.showHideTransitionViews, .transitionFlipFromLeft])
        case .back:
            UIView.transition(from: self.cardBackView, to: self.cardFrontView,
                              duration: 0.5, options: [.showHideTransitionViews, .transitionFlipFromLeft])
        }
    }
}
