//
//  MyCardListDependencyContainer.swift
//  YourName
//
//  Created by Booung on 2021/09/21.
//

import UIKit

final class MyCardListDependencyContainer {
    
    init(signedInDependencyContainer: SignedInDependencyContainer) {
    }
    
    func createMyCardListViewController() -> UIViewController {
        let viewController = MyCardListViewController.instantiate()
        let cardDetailViewControllerFactory: (Identifier) -> NameCardDetailViewController = { cardID in
            let dependencyContainer = self.createCardDetailDependencyContainer(cardID: cardID)
            return dependencyContainer.createNameCardDetailViewController()
        }
        let newCardCreationViewControllerFactory: () -> CardInfoInputViewController = {
            let dependencyContainer = self.createCardInfoInputDependencyContainer()
            return dependencyContainer.createCardInfoInputViewController()
        }
        let questViewControllerFactory: () -> QuestViewController = {
            let dependencyContainer = QuestDependencyContainer()
            return dependencyContainer.createQuestViewController()
        }
        viewController.viewModel = createMyCardListViewModel()
        viewController.cardDetailViewControllerFactory = cardDetailViewControllerFactory
        viewController.newCardCreationViewControllerFactory = newCardCreationViewControllerFactory
        viewController.questViewControllerFactory = questViewControllerFactory
        let naviController = UINavigationController(rootViewController: viewController)
        return naviController
    }
    
    private func createMyCardListViewModel() -> MyCardListViewModel {
        let myCardRepository = YourNameMyCardRepository()
        let questRepository = YourNameQuestRepository()
        return MyCardListViewModel(myCardRepository: myCardRepository,
                                   questRepository: questRepository)
    }
    
    // 👼 Child Dependency Container Factory
    private func createCardDetailDependencyContainer(cardID: Identifier) -> NameCardDetailDependencyContainer {
        return NameCardDetailDependencyContainer(cardID: cardID, myCardListDependencyContainer: self)
    }
    
    private func createCardInfoInputDependencyContainer() -> CardInfoInputDependencyContainer {
        return CardInfoInputDependencyContainer(myCardListDependencyContainer: self)
    }
}
