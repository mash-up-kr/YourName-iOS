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
    
    init() {
        self.addFriendCardRepository = YourNameAddFriendCardRepository()
    }
    
    deinit {
        print("\(String(describing: self)) deinit")
    }
    
    func createAddFriendCardViewController() -> AddFriendCardViewController {
        let viewController = AddFriendCardViewController.instantiate()
        
        let cardDetailVieWControllerFactory: (Int) -> CardDetailViewController = { cardID  in
            let dependencyContainer = self.createCardDetailDependencyContainer(cardID: cardID)
            return dependencyContainer.createCardDetailViewController()
        }
        viewController.viewModel = AddFriendCardViewModel(repository: addFriendCardRepository)
        viewController.cardDetailViewControllerFactory = cardDetailVieWControllerFactory
        
        return viewController
    }
    
    private func createCardDetailDependencyContainer(cardID: Int) -> CardDetailDependencyContainer {
        return CardDetailDependencyContainer(cardID: cardID, addFriendCardDependencyContainer: self)
    }
}
