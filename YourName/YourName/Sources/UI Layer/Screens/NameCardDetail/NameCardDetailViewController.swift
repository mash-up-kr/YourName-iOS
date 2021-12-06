//
//  NameCardDetailViewController.swift
//  MEETU
//
//  Created by Booung on 2021/12/07.
//

import UIKit
import RxSwift
import RxCocoa

final class NameCardDetailViewController: ViewController {
    
    var viewModel: NameCardDetailViewModel!
    
    func bind(to viewModel: NameCardDetailViewModel) {
        self.dispatch(to: viewModel)
        self.render(viewModel)
    }
    
    private func dispatch(to viewModel: NameCardDetailViewModel) {
        self.highlightFrontButton()
        
        self.backButton?.rx.tap
            .subscribe(onNext: { [weak viewModel] in
                viewModel?.tapBack()
            })
            .disposed(by: self.disposeBag)
        
        self.moreButton?.rx.tap
            .subscribe(onNext: { [weak viewModel] in
                viewModel?.tapMore()
            })
            .disposed(by: self.disposeBag)
        
        self.frontCardButton?.rx.tap
            .subscribe(onNext: { [weak viewModel] in
                viewModel?.tapFrontCard()
            })
            .disposed(by: self.disposeBag)
        
        self.backCardButton?.rx.tap
            .subscribe(onNext: { [weak viewModel] in
                viewModel?.tapBackCard()
            })
            .disposed(by: self.disposeBag)
    }
    
    private func render(_ viewModel: NameCardDetailViewModel) {
        viewModel.state
            .filterNil()
            .subscribe(onNext: { [weak self] state in
                switch state {
                case .front(let viewModel):
                    self?.frontCardDetailView?.isHidden = false
                    self?.backCardDetailView?.isHidden = true
                    self?.frontCardDetailView?.configure(with: viewModel)
                    self?.highlightFrontButton()
                    
                case .back(let viewModel):
                    self?.frontCardDetailView?.isHidden = true
                    self?.backCardDetailView?.isHidden = false
                    self?.backCardDetailView?.configure(with: viewModel)
                    self?.highlightBackButton()
                }
            })
            .disposed(by: self.disposeBag)
    }
    
    private func highlightFrontButton() {
        guard let frontCardButton = self.frontCardButton else { return }
        
        self.underlineLeading?.isActive  = false
        self.underlineTrailing?.isActive = false
        
        self.underlineLeading  = nil
        self.underlineTrailing = nil
        
        self.underlineLeading = underlineView?.leadingAnchor.constraint(equalTo: frontCardButton.leadingAnchor)
        self.underlineTrailing = underlineView?.trailingAnchor.constraint(equalTo: frontCardButton.trailingAnchor)
        
        self.underlineLeading?.isActive  = true
        self.underlineTrailing?.isActive = true
    }
    
    private func highlightBackButton() {
        guard let backCardButton = self.backCardButton   else { return }
        
        self.underlineLeading?.isActive  = false
        self.underlineTrailing?.isActive = false
        
        self.underlineLeading  = nil
        self.underlineTrailing = nil
        
        self.underlineLeading = underlineView?.leadingAnchor.constraint(equalTo: backCardButton.leadingAnchor)
        self.underlineTrailing = underlineView?.trailingAnchor.constraint(equalTo: backCardButton.trailingAnchor)
        
        self.underlineLeading?.isActive  = true
        self.underlineTrailing?.isActive = true
    }
    
    private let disposeBag = DisposeBag()
    
    @IBOutlet private weak var backButton: UIButton?
    @IBOutlet private weak var moreButton: UIButton?
    
    @IBOutlet private weak var frontCardButton: UIButton?
    @IBOutlet private weak var backCardButton: UIButton?
    @IBOutlet private weak var underlineView: UIView?
    @IBOutlet private weak var underlineLeading: NSLayoutConstraint?
    @IBOutlet private weak var underlineTrailing: NSLayoutConstraint?
    
    
    @IBOutlet private weak var frontCardDetailView: FrontCardDetailView?
    @IBOutlet private weak var backCardDetailView: BarkCardDetailView?
}
