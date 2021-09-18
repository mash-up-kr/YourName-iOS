//
//  RootContainer.swift
//  YourName
//
//  Created by Booung on 2021/09/17.
//

import Foundation

final class SignedInDependencyContainer {
    
    init(rootDependencyContainer: RootDependencyContainer) {
        // do something
        // get state of rootContainer
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
    
    private func createViewController(of tab: Tab) -> ViewController {
        switch tab {
        case .myCardList: return createMyCardListViewController()
        case .cardBook: return createCardBookViewController()
        case .quest: return createQuestViewContorller()
        case .profile: return createProfileViewController()
        }
    }
    
    private func createMyCardListViewController() -> MyCardListViewController {
        return MyCardListViewController()
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
