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
            let dependencyContainer = createCardDependencyContainer()
            viewController = dependencyContainer.createCardBookViewController()
        case .setting:
            let dependencyContainer = createSettingDependencyContainer()
            viewController = dependencyContainer.settingViewController()
        }
        viewController.tabBarItem = tab.asTabBarItem()
        return viewController
    }

    // 👼 Child Dependency Container Factory
    private func createMyCardListDependencyContainer() -> MyCardListDependencyContainer {
        return MyCardListDependencyContainer(signedInDependencyContainer: self)
    }
    private func createSettingDependencyContainer() -> SettingDependencyContainer {
        return SettingDependencyContainer(signedInDependencyContainer: self)
    }
    
    private func createCardDependencyContainer() -> CardBookDetailDependencyContainer {
        return CardBookDetailDependencyContainer(signedInDependencyContainer: self)
    }
    
    private func createCreateViewController() -> UIViewController {
        let viewController = CreateViewController()
        viewController.view.backgroundColor = .brown
        let naviController = UINavigationController(rootViewController: viewController)
        return naviController
    }
}
