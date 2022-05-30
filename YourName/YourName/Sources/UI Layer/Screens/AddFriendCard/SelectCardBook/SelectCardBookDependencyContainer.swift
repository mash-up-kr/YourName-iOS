//
//  SelectCardBookDependencyContainer.swift
//  MEETU
//
//  Created by Seori on 2022/03/05.
//

import Foundation

final class SelectCardBookDependencyContainer {
    
    deinit {
        print("💀 \(String(describing: self)) deinit")
    }
    
    func createSelectCardBookViewController(friendCardUniqueCode: UniqueCode) -> SelectCardBookViewController {
        let viewController = SelectCardBookViewController.instantiate()
        let viewModel = SelectCardBookViewModel(cardBookRepository: YourNameCardBookRepository(),
                                                addFriendCardRepository: YourNameAddFriendCardRepository(),
                                                questRepository: YourNameQuestRepository(),
                                                friendCardUniqueCode: friendCardUniqueCode)
        viewController.viewModel = viewModel
        return viewController
    }
}
