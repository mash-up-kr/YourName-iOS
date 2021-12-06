//
//  NameCardDetailViewController.swift
//  MEETU
//
//  Created by Booung on 2021/12/07.
//

import UIKit
import RxSwift
import RxCocoa

final class NameCardDetailViewController: ViewController, Storyboarded {
    
    var viewModel: NameCardDetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bind(to: viewModel)
        self.viewModel.didLoad()
    }
    
    func bind(to viewModel: NameCardDetailViewModel) {
        self.dispatch(to: viewModel)
        self.render(viewModel)
    }
    
    private func dispatch(to viewModel: NameCardDetailViewModel) {
        if let frontCardButton = self.frontCardButton { self.highlight(frontCardButton) }
        
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
        viewModel.isLoading
            .bind(to: self.isLoading)
            .disposed(by: self.disposeBag)
        
        viewModel.backgroundColor.filterNil()
            .subscribe(onNext: { [weak self] colorSource in
                self?.view.layoutIfNeeded()
                self?.view.setColorSource(colorSource)
            })
            .disposed(by: self.disposeBag)
        
        viewModel.state
            .filterNil()
            .subscribe(onNext: { [weak self] state in
                guard let self = self else { return }
                switch state {
                case .front(let viewModel):
                    self.view.layoutIfNeeded()
                    self.frontCardDetailView?.isHidden = false
                    self.backCardDetailView?.isHidden = true
                    self.frontCardDetailView?.configure(with: viewModel)
                    if let frontCardButton = self.frontCardButton { self.highlight(frontCardButton) }
                    
                    
                case .back(let viewModel):
                    self.view.layoutIfNeeded()
                    self.frontCardDetailView?.isHidden = true
                    self.backCardDetailView?.isHidden = false
                    self.backCardDetailView?.configure(with: viewModel)
                    if let backCardButton = self.backCardButton { self.highlight(backCardButton) }
                }
            })
            .disposed(by: self.disposeBag)
    }
    
    private func highlight(_ view: UIView) {
        self.underlineLeading?.isActive  = false
        self.underlineTrailing?.isActive = false
        
        self.underlineLeading  = nil
        self.underlineTrailing = nil
        
        self.underlineLeading = underlineView?.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        self.underlineTrailing = underlineView?.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        
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
    @IBOutlet private weak var backCardDetailView: BackCardDetailView?
}
