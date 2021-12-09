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
    
    var cardDetailMoreViewFactory: ((Identifier) -> CardDetailMoreViewController)!
    var cardEditViewControllerFactory: ((Identifier) -> CardInfoInputViewController)!
    var viewModel: NameCardDetailViewModel!
    override var hidesBottomBarWhenPushed: Bool {
        get  { self.navigationController?.topViewController == self }
        set { super.hidesBottomBarWhenPushed = newValue }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.frontCardDetailView?.delegate = self
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
        
        self.rx.viewDidAppear
            .flatMapFirst { [weak self] _ -> Observable<NameCardDetailNavigation> in
                guard let self = self else { return .empty() }
                return self.viewModel.navigation.asObservable()
            }
            .bind(onNext: { [weak self] navigation in
                guard let self = self else { return }
                self.navigate(navigation)
            })
            .disposed(by: self.disposeBag)
        
        self.captureView
            .bind(onNext: { [weak self] in
                self?.viewModel.saveImage(view: $0)
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
                    self.frontCardDetailView?.isHidden = false
                    self.backCardDetailView?.isHidden = true
                    self.view.layoutIfNeeded()
                    self.frontCardDetailView?.configure(with: viewModel)
                    if let frontCardButton = self.frontCardButton { self.highlight(frontCardButton) }
                    
                case .back(let viewModel):
                    self.frontCardDetailView?.isHidden = true
                    self.backCardDetailView?.isHidden = false
                    self.view.layoutIfNeeded()
                    self.backCardDetailView?.configure(with: viewModel)
                    if let backCardButton = self.backCardButton { self.highlight(backCardButton) }
                }
            })
            .disposed(by: self.disposeBag)
        
        viewModel.shouldShowCopyToast
            .subscribe(onNext: { [weak self] in
                let toast = ToastView(text: "코드명이 복사되었츄!")
                self?.view.showToast(toast, position: .top)
            })
            .disposed(by: self.disposeBag)
        
        viewModel.shouldClose
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: self.disposeBag)
        
        viewModel.alertController
            .bind(onNext: { [weak self] in
                self?.present($0, animated: true)
            })
            .disposed(by: self.disposeBag)
        
        viewModel.captureBackCard
            .compactMap { [weak self] in return self?.backCardDetailView?.scrollView }
            .bind(to: self.captureView)
            .disposed(by: self.disposeBag)
        
        viewModel.captureFrontCard
            .compactMap { [weak self] in return self?.frontCardDetailView?.scrollView }
            .bind(to: self.captureView)
            .disposed(by: self.disposeBag)
        
        viewModel.activityViewController
            .bind(onNext: { [weak self] in
                self?.present($0, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
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
    
    private func navigate(_ navigation: NameCardDetailNavigation) {
        let viewController = createViewController(navigation.destination)
        navigate(viewController, action: navigation.action)
    }
    
    private func createViewController(_ next: NameCardDetailDestination) -> UIViewController {
        switch next {
        case .cardDetailMore(let cardID):
            return cardDetailMoreViewFactory(cardID)
        case .cardEdit(let cardID):
            return cardEditViewControllerFactory(cardID)
        }
    }
    
    private let backgroundColor = PublishRelay<ColorSource>()
    private let captureView = PublishRelay<UIScrollView>()
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
extension NameCardDetailViewController: FrontCardDetailViewDelegate {
    
    func frontCardDetailView(_ frontCardDetailView: FrontCardDetailView, didTapCopy id: Identifier) {
        self.viewModel.tapCopy()
    }
    
}
