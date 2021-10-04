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
            let contentView = AddCardView()
            contentView.viewModel = viewModel
            let viewController = PageSheetController(contentView: contentView)
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
