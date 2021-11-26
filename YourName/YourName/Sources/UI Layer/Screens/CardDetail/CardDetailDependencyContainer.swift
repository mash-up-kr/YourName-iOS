//
//  CardDetailDependencyContainer.swift
//  YourName
//
//  Created by Booung on 2021/09/21.
//

import Foundation

final class CardDetailDependencyContainer {
    
    let cardID: Int
    
    init(
        cardID: Int,
        myCardListDependencyContainer: MyCardListDependencyContainer
    ) {
        // do something
        // get state of myCardListDependencyContainer
        self.cardID = cardID
    }
    
    func createCardDetailViewController() -> CardDetailViewController {
        let viewModel = createCardViewModel()
        let viewController = CardDetailViewController.instantiate()
        viewController.viewModel = viewModel
        return viewController
    }
    
    private func createCardViewModel() -> CardDetailViewModel {
        return CardDetailViewModel(cardID: cardID)
    }
}
