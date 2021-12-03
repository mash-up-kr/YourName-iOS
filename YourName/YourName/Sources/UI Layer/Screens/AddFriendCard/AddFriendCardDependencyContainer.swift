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
        
        let cardDetailVieWControllerFactory: (Identifier) -> CardDetailViewController = { cardID  in
            let dependencyContainer = CardDetailDependencyContainer(cardID: cardID)
            return dependencyContainer.createCardDetailViewController()
        }
        viewController.viewModel = AddFriendCardViewModel(addFriendCardRepository: self.addFriendCardRepository,
                                                          cardRepository: self.cardRepository)
        viewController.cardDetailViewControllerFactory = cardDetailVieWControllerFactory
        
        return viewController
    }
}
