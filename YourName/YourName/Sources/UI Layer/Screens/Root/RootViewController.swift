//
//  RootViewController.swift
//  YourName
//
//  Created by Booung on 2021/09/18.
//

import Foundation
import RxSwift

final class RootViewController: ViewController {
    
    init(
        viewModel: RootViewModel,
        splashViewControllerFactory: @escaping () -> SplashViewController,
        signInViewControllerFactory: @escaping () -> SignInViewController,
        homeTabBarControllerFactory: @escaping (AccessToken) -> HomeTabBarController
    ) {
        self.viewModel = viewModel
        self.splashViewControllerFactory = splashViewControllerFactory
        self.signInViewControllerFactory = signInViewControllerFactory
        self.homeTabBarControllerFactory = homeTabBarControllerFactory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.navigation
            .debug("root navigation: ")
            .subscribe(onNext: { [weak self] action in
                guard let self = self else { return }
                guard case .present(let nextPath) = action else { return }
                self.present(next: nextPath)
            }).disposed(by: disposeBag)
    }
    
    override func setupAttribute() {
        self.view.backgroundColor = .cyan
        titleLabel.text = "Root"
        titleLabel.textColor = .black
    }
    
    override func setupLayout() {
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.center.equalTo(self.view)
        }
    }
    
    private func bind() {}
    
    private func present(next: RootPath) {
        if let presentedViewController = self.presentedViewController {
            presentedViewController.dismiss(animated: true, completion: nil)
        }
        let viewController: UIViewController
        switch next {
        case .splash:
            viewController = splashViewControllerFactory()
        case .signedOut:
            viewController = signInViewControllerFactory()
        case .signedIn(let accessToken):
            viewController = homeTabBarControllerFactory(accessToken)
        }
        viewController.modalPresentationStyle = .fullScreen
//        let navigationController = UINavigationController(rootViewController: viewController)
//        navigationController.navigationBar.isHidden = true
        self.present(viewController, animated: true, completion: nil)
    }
    
    
    private let viewModel: RootViewModel
    private let splashViewControllerFactory: () -> SplashViewController
    private let signInViewControllerFactory: () -> SignInViewController
    private let homeTabBarControllerFactory: (AccessToken) -> HomeTabBarController
    private let disposeBag = DisposeBag()
    
    private let titleLabel = UILabel()
}