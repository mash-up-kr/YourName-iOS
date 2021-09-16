//
//  RootContainer.swift
//  YourName
//
//  Created by Booung on 2021/09/17.
//

import Foundation

final class RootContainer {
    
    func rootViewController() -> RootViewController {
        return RootViewController(
            viewModel: rootViewModel(),
            viewControllerFactory: viewController(of:)
        )
    }
    
    private func rootViewModel() -> RootViewModel {
        return RootViewModel()
    }
    
    private func viewController(of tab: Tab) -> ViewController {
        switch tab {
        case .home: return homeViewController()
        case .cardBook: return cardBookViewController()
        case .quest: return questViewContorller()
        case .profile: return profileViewController()
        }
    }
    
    private func homeViewController() -> HomeViewController {
        return HomeViewController()
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
