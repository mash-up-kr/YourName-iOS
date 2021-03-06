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
        
        self.bind()
        self.configureUI()
    }
    
    convenience init(viewModel: CardDetailMoreViewModel,
                     parent: ViewController?) {
        self.init(frame: .zero)
        self.viewModel = viewModel
        self.parent = parent
        self.bind()
        self.configureUI()
    }
    
    deinit {
        print(" 💀 \(String(describing: self)) deinit")
    }
}

extension CardDetailMoreView {
    
    private func configureUI() {
        [self.editView, self.imageSaveView, self.deleteView].forEach { $0.layer.cornerRadius = 12 }
        self.editView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        self.deleteView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
    private func bind() {
        self.render(self.viewModel)
        self.dispatch(to: self.viewModel)
        
        self.imageSaveView.rx.tapWhenRecognized
            .bind(onNext: { [weak self] in
                self?.viewModel.saveImage()
            })
            .disposed(by: disposeBag)
        
        self.deleteView.rx.tapWhenRecognized
            .bind(onNext: { [weak self] in
                self?.viewModel.delete()
            })
            .disposed(by: self.disposeBag)
        
        self.editView.rx.tapWhenRecognized
            .bind(onNext: { [weak self] in
                self?.viewModel.edit()
            })
            .disposed(by: self.disposeBag)
    }
    
    private func render(_ viewModel: CardDetailMoreViewModel) {
        viewModel.dismiss
            .bind(onNext: { [weak self] in
                self?.parent?.dismiss(animated: true)
            })
            .disposed(by: self.disposeBag)
    }
    private func dispatch(to viewModel: CardDetailMoreViewModel) {
        
    }
}

extension CardDetailMoreView: PageSheetContentView {
    var title: String { "" }
    var isModal: Bool { true }
}
