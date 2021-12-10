//
//  AddFriendCardDependencyContainer.swift
//  MEETU
//
//  Created by seori on 2021/11/27.
//

import Foundation
import UIKit

final class AddFriendCardDependencyContainer {
    
    let addFriendCardRepository: AddFriendCardRepository
    let cardRepository: CardRepository
    
    init() {
        self.addFriendCardRepository = YourNameAddFriendCardRepository()
        self.cardRepository = YourNameCardRepository()
    }
    
    deinit {
        print(" 💀 \(String(describing: self)) deinit")
    }
    
    func createAddFriendCardViewController() -> AddFriendCardViewController {
        let viewController = AddFriendCardViewController.instantiate()
        
        let cardDetailVieWControllerFactory: (Identifier) -> NameCardDetailViewController = { cardID  in
            let dependencyContainer = self.createNameCardDetailDependencyContainer(cardID: cardID)
            return dependencyContainer.createNameCardDetailViewController()
        }
        viewController.viewModel = AddFriendCardViewModel(addFriendCardRepository: self.addFriendCardRepository,
                                                          cardRepository: self.cardRepository,
                                                          questRepository: YourNameQuestRepository())
        viewController.cardDetailViewControllerFactory = cardDetailVieWControllerFactory
        
        return viewController
    }
    
    private func createNameCardDetailDependencyContainer(cardID: Identifier) -> NameCardDetailDependencyContainer {
        NameCardDetailDependencyContainer(cardID: cardID, addFriendCardDependencyContainer: self)
    }
}
