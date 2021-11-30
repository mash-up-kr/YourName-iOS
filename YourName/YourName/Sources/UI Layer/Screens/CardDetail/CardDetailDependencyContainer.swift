//
//  CardDetailDependencyContainer.swift
//  YourName
//
//  Created by Booung on 2021/09/21.
//

import Foundation

final class CardDetailDependencyContainer {
    
    let cardID: Int
    let myCardRepository: MyCardRepository
    
    init(
        cardID: Int,
        myCardListDependencyContainer: MyCardListDependencyContainer,
        myCardRepository: MyCardRepository
    ) {
        // do something
        // get state of myCardListDependencyContainer
        self.cardID = cardID
        self.myCardRepository = myCardRepository
    }
    
    func createCardDetailViewController() -> CardDetailViewController {
        let viewModel = createCardViewModel()
        let viewController = CardDetailViewController.instantiate()
        viewController.viewModel = viewModel
        viewController.cardDetailMoreViewFactory = { cardID in
            let view = CardDetailMoreView()
            let viewModel = CardDetailMoreViewModel(repository: self.myCardRepository,
                                                    id: self.cardID)
            view.viewModel = viewModel
            return PageSheetController(contentView: view)
        }
        return viewController
    }
    
    private func createCardViewModel() -> CardDetailViewModel {
        return CardDetailViewModel(cardID: cardID)
    }
}
