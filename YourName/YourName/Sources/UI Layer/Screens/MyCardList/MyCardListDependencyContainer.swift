//
//  MyCardListDependencyContainer.swift
//  YourName
//
//  Created by Booung on 2021/09/21.
//

import UIKit

final class MyCardListDependencyContainer {
    
    init(signedInDependencyContainer: SignedInDependencyContainer) {
//        guard let userOnboarding = UserDefaultManager.userOnboarding,
//              let index = userOnboarding.firstIndex(where: { $0.title == "나의 첫 미츄 만들기" }),
//              let makeFirstMeetU = userOnboarding[safe: index] else { return }
//        if makeFirstMeetU.status == .WAIT {
//
//        }
    }
    
    func createMyCardListViewController() -> UIViewController {
        let viewController = MyCardListViewController.instantiate()
        let cardDetailViewControllerFactory: (CardID) -> CardDetailViewController = { cardID in
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
    private func createCardDetailDependencyContainer(cardID: CardID) -> CardDetailDependencyContainer {
        let myCardRepository = YourNameMyCardRepository()
        return CardDetailDependencyContainer(cardID: cardID,
                                             myCardListDependencyContainer: self,
                                             myCardRepository: myCardRepository)
    }
    
    private func createCardCreationDependencyContainer() -> CardCreationDependencyContainer {
        return CardCreationDependencyContainer(myCardListDependencyContainer: self)
    }
}
