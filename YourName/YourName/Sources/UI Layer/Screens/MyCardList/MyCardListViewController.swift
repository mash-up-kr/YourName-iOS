//
//  HomeViewController.swift
//  YourName
//
//  Created by Booung on 2021/09/17.
//

import RxSwift
import UIKit

final class MyCardListViewController: ViewController {
    
    init(
        viewModel: MyCardListViewModel,
        cardDetailViewControllerFactory: @escaping (String) -> CardDetailViewController
    ) {
        self.viewModel = viewModel
        self.cardDetailViewControllerFactory = cardDetailViewControllerFactory
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        viewModel.load()
        bind()
        
//        #warning("카드 탭 액션 트리거 가구현, 실구현 후 제거해야합니다.") // Booung
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
//            self.viewModel.tapCard(at: 3)
//        })
    }
    
    override func setupLayout() {
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.center.equalTo(self.view)
        }
    }
    
    override func setupAttribute() {
        self.view.backgroundColor = .systemBlue
        titleLabel.text = "MyCardList"
    }
    
    private func bind() {
        self.rx.viewDidAppear.flatMapFirst { _ in self.viewModel.navigation }
            .subscribe(onNext: { [weak self] action in
                guard let self = self else { return }
                self.navigate(action)
            }).disposed(by: disposeBag)
    }
    
    private func navigate(_ action: MyCardListNavigation) {
        let viewController = createViewController(action.destination)
        switch action.action {
        case .present:
            if let presentedViewController = self.presentedViewController {
                presentedViewController.dismiss(animated: false, completion: { [weak self] in
                    viewController.modalPresentationStyle = .fullScreen
                    self?.present(viewController, animated: true, completion: nil)
                })
            } else {
                viewController.modalPresentationStyle = .fullScreen
                self.present(viewController, animated: true, completion: nil)
            }
            
        case .push:
            if let presentedViewController = self.presentedViewController {
                presentedViewController.dismiss(animated: false, completion: { [weak self] in
                    self?.navigationController?.pushViewController(viewController, animated: true)
                })
            } else {
                navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
    
    private func createViewController(_ next: MyCardListDesitination) -> UIViewController {
        switch next {
        case .cardDetail(let cardID):
            return cardDetailViewControllerFactory(cardID)
        }
    }
    
    private let viewModel: MyCardListViewModel
    private let cardDetailViewControllerFactory: (String) -> CardDetailViewController
    private let disposeBag = DisposeBag()
    
    private let titleLabel = UILabel()
}
