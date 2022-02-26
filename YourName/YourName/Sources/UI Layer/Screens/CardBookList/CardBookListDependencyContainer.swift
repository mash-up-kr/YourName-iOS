//
//  CardBookDependencyContainer.swift
//  MEETU
//
//  Created by USER on 2021/10/28.
//

import UIKit

final class CardBookListDependencyContainer {
    
    init(signedInDependencyContainer: SignedInDependencyContainer) {
        
    }
    
    func createCardBookListViewController() -> UIViewController {
        let viewController = CardBookListViewController.instantiate()
        viewController.viewModel = createCardBookListViewModel()
        viewController.cardBookDetailFactory = { id, title in
            let dependencyContainer = self.createCardDetailDependencyContainer()
            return dependencyContainer.createCardBookDetailViewController(cardBookID: id, cardBookTitle: title)
        }
        
        viewController.addCardBookFactory = { [weak self] in
            guard let self = self else { fatalError("self is nil") }
            let dependencyContainer = self.createAddCardBookDependencyContainer()
            return dependencyContainer.createAddCardBookViewController()
        }
        
        viewController.addFriendFactory = {
            let dependencyContainer = self.createAddFriendCardDependencyContainer()
            return dependencyContainer.createAddFriendCardViewController()
        }
        let naviController = UINavigationController(rootViewController: viewController)
        naviController.navigationBar.isHidden = true
        return naviController
    }
    
    private func createAddFriendCardDependencyContainer() -> AddFriendCardDependencyContainer {
        return AddFriendCardDependencyContainer()
    }
    
    private func createAddCardBookDependencyContainer() -> AddCardBookDependencyContainer {
        return AddCardBookDependencyContainer()
    }
    
    private func createCardBookListViewModel() -> CardBookListViewModel {
        let cardBookRepository = createCardBookRepository()
        return CardBookListViewModel(cardBookRepository: cardBookRepository)
    }
    
    private func createCardBookRepository() -> CardBookRepository {
        return YourNameCardBookRepository()
    }
    
    private func createCardDetailDependencyContainer() -> CardBookDetailDependencyContainer {
        return CardBookDetailDependencyContainer(cardBookListDependencyContainer: self)
    }
}
