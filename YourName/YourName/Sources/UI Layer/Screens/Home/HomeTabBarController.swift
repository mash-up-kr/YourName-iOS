//
//  RootViewController.swift
//  YourName
//
//  Created by Booung on 2021/09/10.
//

import UIKit
import RxCocoa
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
        viewModel.tabItems.distinctUntilChanged()
            .subscribe( onNext: { [weak self] tabItems in
                guard let self = self else { return }
                let viewControllers = tabItems.map(self.viewControllerFactory)
                self.setViewControllers(viewControllers, animated: false)
            })
            .disposed(by: disposeBag)
        
        viewModel.currentTab.distinctUntilChanged()
            .map { $0.rawValue }
            .filter { [weak self] in $0 < self?.viewControllers?.count ?? 0 }
            .bind(to: self.rx.selectedIndex)
            .disposed(by: disposeBag)
    }
    
    private let viewModel: HomeViewModel
    private let viewControllerFactory: (Tab) -> ViewController
    private let disposeBag = DisposeBag()
}
