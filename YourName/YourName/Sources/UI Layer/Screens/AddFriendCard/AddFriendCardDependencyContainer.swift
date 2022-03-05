//
//  AddFriendCardDependencyContainer.swift
//  MEETU
//
//  Created by seori on 2021/11/27.
//

import UIKit

final class AddFriendCardDependencyContainer {
    
    private let addFriendCardRepository: AddFriendCardRepository
    private let cardRepository: CardRepository
    
    init() {
        self.addFriendCardRepository = YourNameAddFriendCardRepository()
        self.cardRepository = YourNameCardRepository()
    }
    
    deinit {
        print(" 💀 \(String(describing: self)) deinit")
    }
    
    func createAddFriendCardViewController() -> AddFriendCardViewController {
        let viewController = AddFriendCardViewController.instantiate()
        viewController.viewModel = AddFriendCardViewModel(addFriendCardRepository: self.addFriendCardRepository,
                                                          cardRepository: self.cardRepository,
                                                          questRepository: YourNameQuestRepository())
   
        viewController.selectCardBookViewControllerFactory = {
            SelectCardBookDependencyContainer().createSelectCardBookViewController()
        }
        return viewController
    }
    
}
