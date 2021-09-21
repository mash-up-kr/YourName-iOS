//
//  CardDetailDependencyContainer.swift
//  YourName
//
//  Created by Booung on 2021/09/21.
//

import Foundation

final class CardDetailDependencyContainer {
    
    let cardID: String
    
    init(
        cardID: String,
        myCardListDependencyContainer: MyCardListDependencyContainer
    ) {
        // do something
        // get state of myCardListDependencyContainer
        self.cardID = cardID
    }
    
    func createCardDetailViewController() -> CardDetailViewController {
        let viewModel = createCardViewModel()
        return CardDetailViewController(viewModel: viewModel)
    }
    
    private func createCardViewModel() -> CardDetailViewModel {
        return CardDetailViewModel(cardID: cardID)
    }
}
