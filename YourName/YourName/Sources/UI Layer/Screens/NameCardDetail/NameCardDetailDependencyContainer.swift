//
//  NameCardDetailDependencyContainer.swift
//  MEETU
//
//  Created by Booung on 2021/12/07.
//

import Foundation

final class NameCardDetailDependencyContainer {
    
    let cardID: Identifier
    
    init(cardID: Identifier, myCardListDependencyContainer: MyCardListDependencyContainer) {
        self.cardID = cardID
    }
    
    init(cardID: Identifier, cardListDependencyContainer: CardBookListDependencyContainer) {
        self.cardID = cardID
    }
    
    init(cardID: Identifier, cardBookDetailDependencyContainer: CardBookDetailDependencyContainer) {
        self.cardID = cardID
    }
    
    init(cardID: Identifier, addFriendCardDependencyContainer: AddFriendCardDependencyContainer) {
        self.cardID = cardID
    }
    
    func createNameCardDetailViewController() -> NameCardDetailViewController {
        let viewController = NameCardDetailViewController.instantiate()
        viewController.viewModel = self.createNameCardDetailViewModel()
        return viewController
    }
    
    private func createNameCardDetailViewModel() -> NameCardDetailViewModel {
        let cardRepository = self.createCardRepository()
        let clipboardService = self.createClipboardService()
        return NameCardDetailViewModel(cardID: cardID,
                                       cardRepository: cardRepository,
                                       clipboardService: clipboardService)
    }
    
    private func createCardRepository() -> CardRepository {
        return YourNameCardRepository()
    }
    
    private func createClipboardService() -> ClipboardService {
        return YourNameClipboardService()
    }
    
}
