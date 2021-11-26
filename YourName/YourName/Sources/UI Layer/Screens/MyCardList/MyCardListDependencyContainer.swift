//
//  MyCardListDependencyContainer.swift
//  YourName
//
//  Created by Booung on 2021/09/21.
//

import UIKit

final class MyCardListDependencyContainer {
    
    init(signedInDependencyContainer: SignedInDependencyContainer) {
        // do something
        // get state of signedInDependencyContainer
    }
    
    func createMyCardListViewController() -> UIViewController {
        let viewController = MyCardListViewController.instantiate()
        let cardDetailViewControllerFactory: (Int) -> CardDetailViewController = { cardID in
            let dependencyContainer = self.createCardDetailDependencyContainer(cardID: cardID)
            return dependencyContainer.createCardDetailViewController()
        }
        let cardCreationViewControllerFactory: () -> CardCreationViewController = {
            let dependencyContainer = self.createCardCreationDependencyContainer()
            return dependencyContainer.createCardCreationViewController()
        }
        viewController.viewModel = createMyCardListViewModel()
        viewController.cardDetailViewControllerFactory = cardDetailViewControllerFactory
        viewController.cardCreationViewControllerFactory = cardCreationViewControllerFactory
        let naviController = UINavigationController(rootViewController: viewController)
        return naviController
    }
    
    private func createMyCardListViewModel() -> MyCardListViewModel {
        let myCardRepository = YourNameMyCardRepository()
        return MyCardListViewModel(myCardRepository: myCardRepository)
    }
    
    // 👼 Child Dependency Container Factory
    private func createCardDetailDependencyContainer(cardID: Int) -> CardDetailDependencyContainer {
        return CardDetailDependencyContainer(cardID: cardID, myCardListDependencyContainer: self)
    }
    
    private func createCardCreationDependencyContainer() -> CardCreationDependencyContainer {
        return CardCreationDependencyContainer(myCardListDependencyContainer: self)
    }
}
