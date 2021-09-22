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
        signInViewControllerFactory: @escaping () -> SignInViewController,
        homeTabBarControllerFactory: @escaping (AccessToken) -> HomeTabBarController
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
        
        bind()
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
    
    private func bind() {
        self.rx.viewDidAppear.flatMapFirst { _ in self.viewModel.navigation }
            .subscribe(onNext: { [weak self] action in
                guard let self = self else { return }
                self.navigate(action)
            }).disposed(by: disposeBag)
    }
    
    private func navigate(_ action: RootNavigation) {
        let viewController = createViewController(action.destination)
        switch action.action {
        case .present:
            if let presentingViewController = presentingViewController {
                presentingViewController.dismiss(animated: false, completion: { [weak self] in
                    viewController.modalPresentationStyle = .fullScreen
                    self?.present(viewController, animated: true, completion: nil)
                })
            } else {
                viewController.modalPresentationStyle = .fullScreen
                self.present(viewController, animated: true, completion: nil)
            }
            
        case .push:
            if let presentingViewController = presentingViewController {
                presentingViewController.dismiss(animated: false, completion: { [weak self] in
                    self?.navigationController?.pushViewController(viewController, animated: true)
                })
            } else {
                navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
    
    private func createViewController(_ next: RootDestination) -> UIViewController {
        switch next {
        case .splash: return splashViewControllerFactory()
        case .signedOut: return signInViewControllerFactory()
        case .signedIn(let accessToken): return homeTabBarControllerFactory(accessToken)
        }
    }
    
    private let viewModel: RootViewModel
    private let splashViewControllerFactory: () -> SplashViewController
    private let signInViewControllerFactory: () -> SignInViewController
    private let homeTabBarControllerFactory: (AccessToken) -> HomeTabBarController
    private let disposeBag = DisposeBag()
    
    private let titleLabel = UILabel()
}
