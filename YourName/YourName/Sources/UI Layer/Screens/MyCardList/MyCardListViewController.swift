//
//  HomeViewController.swift
//  YourName
//
//  Created by Booung on 2021/09/17.
//

import RxSwift
import UIKit

final class MyCardListViewController: ViewController, Storyboarded {
    
    var viewModel: MyCardListViewModel!
    var cardDetailViewControllerFactory: ((String) -> CardDetailViewController)!
    var cardCreationViewControllerFactory: (() -> CardCreationViewController)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        viewModel.load()
        bind()
        
//        #warning("카드 탭 액션 트리거 가구현, 실구현 후 제거해야합니다.") // Booung
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
//            self.viewModel.tapCard(at: 3)
            self.viewModel.tapCardCreation()
        })
    }
    
    private func bind() {
        self.rx.viewDidAppear.flatMapFirst { _ in self.viewModel.navigation }
            .subscribe(onNext: { [weak self] action in
                guard let self = self else { return }
                self.navigate(action)
            }).disposed(by: disposeBag)
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
}
