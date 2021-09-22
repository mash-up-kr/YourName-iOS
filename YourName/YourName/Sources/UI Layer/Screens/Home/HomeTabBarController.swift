//
//  RootViewController.swift
//  YourName
//
//  Created by Booung on 2021/09/10.
//

import UIKit
import RxCocoa
import RxOptional
import RxSwift

final class HomeTabBarController: UITabBarController {
    
    init(
        viewModel: HomeViewModel,
        viewControllerFactory: @escaping (Tab) -> ViewController
    ) {
        self.viewModel = viewModel
        self.viewControllerFactory = viewControllerFactory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAttributes()
        bind()
    }
    
    private func setupAttributes() {
    }
    
    private func bind() {
        self.rx.didSelect.distinctUntilChanged()
            .map { [weak self] selected in self?.viewControllers?.firstIndex(where: { selected === $0 }) }
            .filterNil()
            .subscribe(onNext: { [weak self] in
                self?.viewModel.selectTab(index: $0)
            })
            .disposed(by: disposeBag)
        
        viewModel.tabItems.distinctUntilChanged()
            .subscribe( onNext: { [weak self] tabItems in
                guard let self = self else { return }
                let viewControllers = tabItems.map(self.viewControllerFactory)
                    .map { UINavigationController(rootViewController: $0) }
                self.setViewControllers(viewControllers, animated: false)
            })
            .disposed(by: disposeBag)
        
        viewModel.currentTab.distinctUntilChanged()
            .map { $0.rawValue }
            .filter { [weak self] currentTab in
                let isVaildTab = currentTab < self?.viewControllers?.count ?? 0
                let isNotSameTab = currentTab != self?.selectedIndex
                return isVaildTab && isNotSameTab
            }
            .bind(to: self.rx.selectedIndex)
            .disposed(by: disposeBag)
    }
    
    private let viewModel: HomeViewModel
    private let viewControllerFactory: (Tab) -> ViewController
    private let disposeBag = DisposeBag()
}
