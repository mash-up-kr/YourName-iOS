//
//  CardBookDetailOptionView.swift
//  MEETU
//
//  Created by Seori on 2022/03/12.
//

import UIKit
import RxSwift
import RxCocoa

typealias CardBookDetailOptionViewController = PageSheetController<CardBookDetailOptionView>

final class CardBookDetailOptionView: UIView, PageSheetContentView, NibLoadable {
    var parent: ViewController?
    var title: String { "" }
    var isModal: Bool { true }
    
    @IBOutlet private unowned var cardBookDeleteLabel: UILabel!
    @IBOutlet private unowned var cardBookStackView: UIStackView!
    @IBOutlet private unowned var friendStackView: UIStackView!
    @IBOutlet private unowned var broughtFriendView: UIView!
    @IBOutlet private unowned var deleteFriendView: UIView!
    @IBOutlet private unowned var editCardBookView: UIView!
    @IBOutlet private unowned var deleteCardBookView: UIView!
    
    private let disposeBag: DisposeBag = .init()
    private var viewModel: CardBookDetailOptionViewModel!
    private var cardBookTitle: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupFromNib()
    }
    
    /// do not init by coder
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupFromNib()
        self.bind()
        self.configureUI()
    }
    
    convenience init(viewModel: CardBookDetailOptionViewModel,
                     cardBookTitle: String?,
                     parent: ViewController?) {
        self.init(frame: .zero)
        self.viewModel = viewModel
        self.parent = parent
        self.cardBookTitle = cardBookTitle
        self.bind()
        self.configureUI()
    }
    deinit {
        print(" 💀 \(String(describing: self)) deinit")
    }
}

// MARK: - Private

extension CardBookDetailOptionView {
    private func bind() {
        
        self.render(viewModel: self.viewModel)
        self.dispatch(viewModel: self.viewModel)
        
        self.broughtFriendView.rx.tapWhenRecognized
            .bind(onNext: { [weak viewModel] in
                viewModel?.didTapBroughtFriend()
            })
            .disposed(by: self.disposeBag)
        
        self.deleteFriendView.rx.tapWhenRecognized
            .bind(onNext: { [weak viewModel] in
                viewModel?.didTapDeleteFriend()
            })
            .disposed(by: self.disposeBag)
        
        self.editCardBookView.rx.tapWhenRecognized
            .bind(onNext: { [weak viewModel] in
                viewModel?.didTapEditCardBook()
            })
            .disposed(by: self.disposeBag)
        
        self.deleteCardBookView.rx.tapWhenRecognized
            .bind(onNext: { [weak viewModel] in
                viewModel?.didTapDeleteCardBook()
            })
            .disposed(by: self.disposeBag)
    }
    
    private func configureUI() {
        [self.friendStackView, self.cardBookStackView].forEach { stackView in
            stackView?.layer.cornerRadius = 12
            stackView?.clipsToBounds = true
        }
        self.cardBookDeleteLabel.text = "\(self.cardBookTitle ?? "") 도감 삭제하기"
    }
    
    private func render(viewModel: CardBookDetailOptionViewModel) { }
    private func dispatch(viewModel: CardBookDetailOptionViewModel) {
        viewModel.shouldDismiss
            .bind(onNext: { [weak self] in
                self?.parent?.dismiss(animated: true)
            })
            .disposed(by: self.disposeBag)
    }
}
