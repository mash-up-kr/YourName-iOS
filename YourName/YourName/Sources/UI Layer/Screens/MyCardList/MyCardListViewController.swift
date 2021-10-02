//
//  HomeViewController.swift
//  YourName
//
//  Created by Booung on 2021/09/17.
//

import RxOptional
import RxSwift
import UIKit

final class MyCardListViewController: ViewController, Storyboarded {
    
    var viewModel: MyCardListViewModel!
    var cardDetailViewControllerFactory: ((String) -> CardDetailViewController)!
    var cardCreationViewControllerFactory: (() -> CardCreationViewController)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        
        bind()
    }
    
    func presentVC() {
        let contentView = UIView().then { $0.backgroundColor = .brown }
        contentView.snp.makeConstraints {
            $0.height.equalTo(350)
        }
        let pageSheetController = PageSheetController(contentView: contentView)
        pageSheetController.modalPresentationStyle = .fullScreen
        self.present(pageSheetController, animated: false, completion: nil)
    }
    
    private func bind() {
        dispatch(to: viewModel)
        render(viewModel)
    }
    
    private func dispatch(to viewModel: MyCardListViewModel) {
        viewModel.load()
        
        self.rx.viewDidAppear.flatMapFirst { _ in self.viewModel.navigation}
            .subscribe(onNext: { [weak self] action in
                guard let self = self else { return }
                self.navigate(action)
            }).disposed(by: disposeBag)
        
        addCardButton?.rx.tap.subscribe(onNext: { self.presentVC() })
//            .subscribe(onNext: { [weak self] _ in self?.viewModel.tapCardCreation() }       )
            .disposed(by: disposeBag)
    }
    
    private func render(_ viewModel: MyCardListViewModel) {
        
    }
    
    private func navigate(_ navigation: MyCardListNavigation) {
        let viewController = createViewController(navigation.destination)
        navigate(viewController, action: navigation.action)
    }
    
    private func createViewController(_ next: MyCardListDesitination) -> UIViewController {
        switch next {
        case .cardDetail(let cardID):
            return cardDetailViewControllerFactory(cardID)
        case .cardCreation:
            return cardCreationViewControllerFactory()
        }
    }
    
    private let disposeBag = DisposeBag()
    @IBOutlet private weak var addCardButton: UIButton?
}
