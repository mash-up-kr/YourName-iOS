//
//  RootContainer.swift
//  YourName
//
//  Created by Booung on 2021/09/17.
//

import Foundation

final class SignedInContainer {
    
    func homeViewController() -> HomeTabBarController {
        return HomeTabBarController(
            viewModel: homeViewModel(),
            viewControllerFactory: viewController(of:)
        )
    }
    
    private func homeViewModel() -> HomeViewModel {
        return HomeViewModel()
    }
    
    private func viewController(of tab: Tab) -> ViewController {
        switch tab {
        case .myCardList: return homeViewController()
        case .cardBook: return cardBookViewController()
        case .quest: return questViewContorller()
        case .profile: return profileViewController()
        }
    }
    
    private func homeViewController() -> MyCardListViewController {
        return MyCardListViewController()
    }
    
    private func cardBookViewController() -> CardBookViewController {
        return CardBookViewController()
    }
    
    private func questViewContorller() -> QuestViewController {
        return QuestViewController()
    }
    
    private func profileViewController() -> ProfileViewController {
        return ProfileViewController()
    }
}
