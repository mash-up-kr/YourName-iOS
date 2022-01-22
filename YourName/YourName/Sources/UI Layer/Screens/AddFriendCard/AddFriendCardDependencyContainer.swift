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
        
        let cardDetailVieWControllerFactory: (UniqueCode) -> NameCardDetailViewController = { uniqueCode  in
            let dependencyContainer = self.createNameCardDetailDependencyContainer(uniqueCode: uniqueCode)
            return dependencyContainer.createNameCardDetailViewController()
        }
        viewController.viewModel = AddFriendCardViewModel(addFriendCardRepository: self.addFriendCardRepository,
                                                          cardRepository: self.cardRepository,
                                                          questRepository: YourNameQuestRepository())
        viewController.cardDetailViewControllerFactory = cardDetailVieWControllerFactory
        
        return viewController
    }
    
    private func createNameCardDetailDependencyContainer(uniqueCode: UniqueCode) -> NameCardDetailDependencyContainer {
        NameCardDetailDependencyContainer(uniqueCode: uniqueCode, addFriendCardDependencyContainer: self)
    }
}
