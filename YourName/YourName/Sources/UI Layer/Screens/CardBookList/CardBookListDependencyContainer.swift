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
        viewController.cardBookDetailFactory = { id in
            let dependencyContainer = self.createCardDetailDependencyContainer()
            return dependencyContainer.createCardBookDetailViewController(cardBookID: id)
        }
        
        let naviController = UINavigationController(rootViewController: viewController)
        naviController.navigationBar.isHidden = true
        return naviController
    }
    
    private func createCardBookListViewModel() -> CardBookListViewModel {
        let cardBookRepository = createCardBookRepository()
        return CardBookListViewModel(cardBookRepository: cardBookRepository)
    }
    
    private func createCardBookRepository() -> CardBookRepository {
        return MockCardBookRepository()
    }
    
    private func createCardDetailDependencyContainer() -> CardBookDetailDependencyContainer {
        return CardBookDetailDependencyContainer(cardBookListDependencyContainer: self)
    }
}
