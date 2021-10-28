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
            let viewModel = AddFriendCardViewModel()
            let contentView = AddFriendCardView()
            contentView.viewModel = viewModel
            let viewController = PageSheetController(contentView: contentView)
            return viewController
        }
        viewController.viewModel = viewModel
        viewController.addFriendCardViewControllerFactory = addCardViewControllerFactory
        return viewController
    }
    
    private func createCardBookDetailViewModel() -> CardBookDetailViewModel {
        let cardBookRepository = CardBookRepository()
        return CardBookDetailViewModel(cardBookRepository: cardBookRepository)
    }
}
