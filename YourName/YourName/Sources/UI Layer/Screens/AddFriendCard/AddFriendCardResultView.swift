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
    
    @IBOutlet private unowned var cardView: MyCardView!
    @IBOutlet private unowned var cardBackView: AddFriendCardBackView!
    @IBOutlet private unowned var flipButton: UIButton!
    @IBOutlet private unowned var addButton: UIButton!
    
    
    private let viewModel = AddFriendCardResultViewModel()
    private let disposeBag = DisposeBag()
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
    func configureCardView(frontItem: MyCardView.Item,
                           backItem: AddFriendCardBackView.Item) {
        self.cardView.configure(item: frontItem)
        self.cardBackView.configure(item: backItem)
    }
    
    private func bind() {
        flipButton.rx.throttleTap
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                let transitionOptions: UIView.AnimationOptions = [.transitionFlipFromRight, .showHideTransitionViews]
                
                UIView.transition(with: self.cardView,
                                  duration: 1.0,
                                  options: transitionOptions, animations: {
                    self.cardView.isHidden = true
                })
                
                UIView.transition(with: self.cardBackView,
                                  duration: 1.0,
                                  options: transitionOptions, animations: {
                    self.cardBackView.isHidden = false
                })
            })
            .disposed(by: disposeBag)
    }
    private func render(viewModel: AddFriendCardResultViewModel) {
        
    }
}
