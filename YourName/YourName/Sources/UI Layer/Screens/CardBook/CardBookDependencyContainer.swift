//
//  CardBookDependencyContainer.swift
//  YourName
//
//  Created by seori on 2021/10/04.
//

import Foundation
import UIKit

final class CardBookDependencyContainer {
    
    init(signedInDependencyContainer: SignedInDependencyContainer) {
        
    }
    
    func createCardBookViewController() -> UIViewController {
        let viewController = CardBookViewController.instantiate()
        let viewModel = createCardBookViewModel()
        let addCardViewControllerFactory: () -> AddCardViewController = {
            let viewModel = AddCardViewModel()
            let viewController = AddCardViewController.instantiate()
            viewController.viewModel = viewModel
            return viewController
        }
        viewController.viewModel = viewModel
        viewController.addCardViewControllerFactory = addCardViewControllerFactory
        return viewController
    }
    
    private func createCardBookViewModel() -> CardBookViewModel {
        let cardBookRepository = CardBookRepository()
        return CardBookViewModel(cardBookRepository: cardBookRepository)
    }
}
