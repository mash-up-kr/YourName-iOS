//
//  RootViewController.swift
//  YourName
//
//  Created by Booung on 2021/09/18.
//

import RxSwift
import RxViewController

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
                guard case .present(let nextPath) = action else { return }
                self.present(next: nextPath)
            }).disposed(by: disposeBag)
    }
    
    private func present(next: RootPath) {
        switch next {
        case .splash:
            presentSplash()
            
        case .signedOut:
            if let presentedViewController = self.presentedViewController {
                presentedViewController.dismiss(animated: true, completion: {
                    self.presentSignIn()
                })
            } else {
                self.presentSignIn()
            }
            
        case .signedIn(let accessToken):
            if let presentedViewController = self.presentedViewController {
                presentedViewController.dismiss(animated: true, completion: {
                    self.presentHome(with: accessToken)
                })
            } else {
                self.presentHome(with: accessToken)
            }
        }
    }
    
    private func presentSplash() {
        let viewController = splashViewControllerFactory()
        let naviController = UINavigationController(rootViewController: viewController)
        naviController.navigationBar.isHidden = true
        naviController.modalPresentationStyle = .fullScreen
        self.present(naviController, animated: false, completion: nil)
    }
    
    private func presentSignIn() {
        let viewController = signInViewControllerFactory()
        let naviController = UINavigationController(rootViewController: viewController)
        naviController.navigationBar.isHidden = true
        naviController.modalPresentationStyle = .fullScreen
        self.present(naviController, animated: true, completion: nil)
    }
    
    private func presentHome(with accessToken: AccessToken) {
        let viewController = homeTabBarControllerFactory(accessToken)
        let naviController = UINavigationController(rootViewController: viewController)
        naviController.navigationBar.isHidden = true
        naviController.modalPresentationStyle = .fullScreen
        self.present(naviController, animated: true, completion: nil)
    }
    
    private let viewModel: RootViewModel
    private let splashViewControllerFactory: () -> SplashViewController
    private let signInViewControllerFactory: () -> SignInViewController
    private let homeTabBarControllerFactory: (AccessToken) -> HomeTabBarController
    private let disposeBag = DisposeBag()
    
    private let titleLabel = UILabel()
}
