//
//  CardDetailDependencyContainer.swift
//  YourName
//
//  Created by Booung on 2021/09/21.
//

import Foundation

final class CardDetailDependencyContainer {
    
    let cardID: Identifier
    
    init(
        cardID: Identifier,
        myCardListDependencyContainer: MyCardListDependencyContainer
    ) {
        // do something
        // get state of myCardListDependencyContainer
        self.cardID = cardID
    }
    
    init(cardID: Identifier) {
        self.cardID = cardID
    }
    
    func createCardDetailViewController() -> CardDetailViewController {
        let viewModel = createCardViewModel()
        let viewController = CardDetailViewController.instantiate()
        viewController.viewModel = viewModel
        return viewController
    }
    
    private func createCardViewModel() -> CardDetailViewModel {
        let cardRepository = self.createCardRepository()
        return CardDetailViewModel(cardID: cardID, cardRepository: cardRepository)
    }
    
    private func createCardRepository() -> CardRepository {
        return YourNameCardRepository()
    }
}
