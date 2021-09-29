//
//  RootContainer.swift
//  YourName
//
//  Created by Booung on 2021/09/17.
//

import UIKit

final class SignedInDependencyContainer {
    
    let accessToken: AccessToken
    
    init(
        accessToken: AccessToken,
        rootDependencyContainer: RootDependencyContainer
    ) {
        // do something
        // get state of rootDependencyContainer
        self.accessToken = accessToken
    }
    
    func createHomeViewController() -> HomeTabBarController {
        return HomeTabBarController(
            viewModel: createHomeViewModel(),
            viewControllerFactory: createViewController(of:)
        )
    }
    
    private func createHomeViewModel() -> HomeViewModel {
        return HomeViewModel()
    }
    
    private func createViewController(of tab: HomeTab) -> UIViewController {
        let viewController: UIViewController
        switch tab {
        case .myCardList:
            let dependencyContainer = createMyCardListDependencyContainer()
            viewController = dependencyContainer.createMyCardListViewController()
        case .cardBook:
            viewController = createCardBookViewController()
        case .setting:
            viewController = createSettingViewController()
        }
        viewController.tabBarItem = tab.asTabBarItem()
        return viewController
    }

    // Child Dependency Container Factory
    private func createMyCardListDependencyContainer() -> MyCardListDependencyContainer {
        return MyCardListDependencyContainer(signedInDependencyContainer: self)
    }
    
    private func createCardBookViewController() -> UIViewController {
        let viewController = CardBookViewController.instantiate()
        let naviController = UINavigationController(rootViewController: viewController)
        return naviController
    }
    
    private func createSettingViewController() -> UIViewController {
        let viewController = SettingViewController.instantiate()
        let naviController = UINavigationController(rootViewController: viewController)
        return naviController
    }
    
    private func createCreateViewController() -> UIViewController {
        let viewController = CreateViewController()
        viewController.view.backgroundColor = .brown
        let naviController = UINavigationController(rootViewController: viewController)
        return naviController
    }
}
