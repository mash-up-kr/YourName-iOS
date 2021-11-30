//
//  CardDetailMoreView.swift
//  MEETU
//
//  Created by seori on 2021/11/30.
//

import UIKit
import RxSwift
import RxCocoa

typealias CardDetailMoreViewController = PageSheetController<CardDetailMoreView>

final class CardDetailMoreView: UIView, NibLoadable {
    
    @IBOutlet private unowned var imageSaveView: UIView!
    @IBOutlet private unowned var shareLinkView: UIView!
    @IBOutlet private unowned var editView: UIView!
    @IBOutlet private unowned var deleteView: UIView!
    
    var viewModel: CardDetailMoreViewModel!
    var parent: ViewController?
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupFromNib()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupFromNib()
    }
}

extension CardDetailMoreView {
    private func bind() {
        self.imageSaveView.rx.tapWhenRecognized()
            .bind(onNext: { [weak self] in
                print("image save button tapped")
            })
            .disposed(by: disposeBag)
        
        self.deleteView.rx.tapWhenRecognized()
            .bind(onNext: { [weak self] in
                self?.viewModel.delete()
            })
            .disposed(by: disposeBag)
    }
    
    private func render(_ viewModel: CardDetailMoreViewModel) {
        viewModel.alertController
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                self.parent?.present($0, animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.popToRootViewController
            .bind(onNext: { [weak self] in
                self?.parent?.navigationController?.popToRootViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
    private func dispatch(to viewModel: CardDetailMoreViewModel) {
        
    }
}

extension CardDetailMoreView: PageSheetContentView {
    var title: String { "" }
    var isModal: Bool { true }
}
