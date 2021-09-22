//
//  RootContainer.swift
//  YourName
//
//  Created by Booung on 2021/09/17.
//

import Foundation

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
    
    private func createViewController(of tab: HomeTab) -> ViewController {
        switch tab {
        case .myCardList:
            let dependencyContainer = createMyCardListDependencyContainer()
            return dependencyContainer.createMyCardListViewController()
        case .cardBook: return createCardBookViewController()
        case .quest: return createQuestViewContorller()
        case .profile: return createProfileViewController()
        }
    }
    
    // Child Dependency Container Factory
    private func createMyCardListDependencyContainer() -> MyCardListDependencyContainer {
        return MyCardListDependencyContainer(signedInDependencyContainer: self)
    }
    
    private func createCardBookViewController() -> CardBookViewController {
        return CardBookViewController()
    }
    
    private func createQuestViewContorller() -> QuestViewController {
        return QuestViewController()
    }
    
    private func createProfileViewController() -> ProfileViewController {
        return ProfileViewController()
    }
}
