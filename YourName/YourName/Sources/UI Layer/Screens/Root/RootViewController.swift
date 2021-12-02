//
//  RootViewController.swift
//  YourName
//
//  Created by Booung on 2021/09/18.
//

import RxSwift
import RxViewController
import UIKit

final class RootViewController: ViewController {
    
    init(
        viewModel: RootViewModel,
        splashViewControllerFactory: @escaping () -> SplashViewController,
        signInViewControllerFactory: @escaping () -> WelcomeViewController,
        homeTabBarControllerFactory: @escaping (Secret, Secret) -> HomeTabBarController
    ) {
        self.viewModel = viewModel
        self.splashViewControllerFactory = splashViewControllerFactory
        self.signInViewControllerFactory = signInViewControllerFactory
        self.homeTabBarControllerFactory = homeTabBarControllerFactory
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        bind()
    }
    
    private func bind() {
        self.rx.viewDidAppear.flatMapFirst { _ in self.viewModel.navigation }
            .subscribe(onNext: { [weak self] action in
                guard let self = self else { return }
                self.navigate(action)
            }).disposed(by: disposeBag)
    }
    
    private func navigate(_ navigation: RootNavigation) {
        let viewController = createViewController(navigation.destination)
        self.navigate(viewController, action: navigation.action)
    }
    
    private func createViewController(_ next: RootDestination) -> UIViewController {
        switch next {
        case .splash: return splashViewControllerFactory()
        case .signedOut: return signInViewControllerFactory()
        case .signedIn(let accessToken, let refreshToken): return homeTabBarControllerFactory(accessToken, refreshToken)
        }
    }
    
    private let viewModel: RootViewModel
    private let splashViewControllerFactory: () -> SplashViewController
    private let signInViewControllerFactory: () -> WelcomeViewController
    private let homeTabBarControllerFactory: (Secret, Secret) -> HomeTabBarController
    private let disposeBag = DisposeBag()
    
    private let titleLabel = UILabel()
}
