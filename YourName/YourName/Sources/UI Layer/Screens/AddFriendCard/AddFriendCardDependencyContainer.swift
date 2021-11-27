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
    
    func createAddFriendCardViewController() -> AddFriendCardViewController {
        let viewController = AddFriendCardViewController.instantiate()
        viewController.viewModel = AddFriendCardViewModel(repository: addFriendCardRepository)
        
        return viewController
    }
}
