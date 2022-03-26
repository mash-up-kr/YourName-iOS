//
//  CardBookMoreView.swift
//  MEETU
//
//  Created by Seori on 2022/03/26.
//

import UIKit
import RxSwift
import RxCocoa

typealias CardBookMoreViewController = PageSheetController<CardBookMoreView>

final class CardBookMoreView: UIView, NibLoadable {
    
    @IBOutlet private unowned var memeberStackView: UIStackView!
    @IBOutlet private unowned var editStackView: UIStackView!
    @IBOutlet private unowned var addMemberView: UIView!
    @IBOutlet private unowned var deleteMemberView: UIView!
    @IBOutlet private unowned var cardBookEditView: UIView!
    @IBOutlet private unowned var cardBookDeleteView: UIView!
    @IBOutlet private unowned var cardBookDeleteLabel: UILabel!
    
    var parent: ViewController?
    private var viewModel: CardBookMoreViewModel!
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupFromNib()
    }
    
    required init?(coder: NSCoder) {
        fatalError("do not init from coder")
    }
    
    convenience init(viewModel: CardBookMoreViewModel,
                     parent: ViewController?) {
        self.init(frame: .zero)
        self.viewModel = viewModel
        self.parent = parent
        self.render(self.viewModel)
        self.dispatch(to: self.viewModel)
        self.configureUI()
    }
    deinit {
        print(" 💀 \(String(describing: self)) deinit")
    }
}

extension CardBookMoreView {
    func configureUI() {
        editStackView.cornerRadius = 12
        memeberStackView.cornerRadius = 12
        editStackView.clipsToBounds = true
        memeberStackView.clipsToBounds = true
    }
    func render(_ viewModel: CardBookMoreViewModel) {
        viewModel.isCardEmpty
            .filter { $0 }
            .bind(onNext: { [weak self] _ in
                self?.deleteMemberView.isHidden = true
            })
            .disposed(by: self.disposeBag)
        
        viewModel.cardBookName
            .bind(onNext: { [weak self] cardBookName in
                self?.cardBookDeleteLabel.text = "\(cardBookName) 도감 삭제하기"
            })
            .disposed(by: self.disposeBag)
        
        viewModel.dismiss
            .bind(onNext: { [weak self] in
                self?.parent?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: self.disposeBag)
    }
    func dispatch(to viewModel: CardBookMoreViewModel) {

        self.addMemberView.rx.tapWhenRecognized
            .bind(onNext: { _ in
                viewModel.didTapAddMember()
            })
            .disposed(by: self.disposeBag)
        
        self.deleteMemberView.rx.tapWhenRecognized
            .bind(onNext: { _ in
                viewModel.didTapDeleteMember()
            })
            .disposed(by: self.disposeBag)
        
        self.cardBookEditView.rx.tapWhenRecognized
            .bind(onNext: { _ in
                
                viewModel.didTapEditCardBook()
            })
            .disposed(by: self.disposeBag)
        
        self.cardBookDeleteView.rx.tapWhenRecognized
            .bind(onNext: { _ in
                viewModel.didTapDeleteCardBook()
            })
            .disposed(by: self.disposeBag)
    }
}

// MARK: - PageSheetContentView

extension CardBookMoreView: PageSheetContentView {
    var title: String { "" }
    var isModal: Bool { true }
}
