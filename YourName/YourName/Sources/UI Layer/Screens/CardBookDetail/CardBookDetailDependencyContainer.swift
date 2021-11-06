//
//  CardBookDependencyContainer.swift
//  YourName
//
//  Created by seori on 2021/10/04.
//

import Foundation
import UIKit

final class CardBookDetailDependencyContainer {
    
    init(signedInDependencyContainer: SignedInDependencyContainer) {
        
    }
    
    func createCardBookViewController() -> UIViewController {
        let viewController = CardBookDetailViewController.instantiate()
        let viewModel = createCardBookDetailViewModel()
        let addCardViewControllerFactory: () -> AddFriendCardViewController = {
            let viewController = AddFriendCardViewController.instantiate()
            let viewModel = AddFriendCardViewModel()
            viewController.viewModel = viewModel
            return viewController
        }
        viewController.viewModel = viewModel
        viewController.addFriendCardViewControllerFactory = addCardViewControllerFactory
        let navigationController = UINavigationController(rootViewController: viewController)
        return navigationController
    }
    
    private func createCardBookDetailViewModel() -> CardBookDetailViewModel {
        let cardBookRepository = CardBookRepository()
        return CardBookDetailViewModel(cardBookRepository: cardBookRepository)
    }
}
