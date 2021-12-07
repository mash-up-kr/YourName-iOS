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
        let viewModel = createNameCardDetailViewModel()
        viewController.viewModel = viewModel
        
        viewController.cardDetailMoreViewFactory = { cardID -> CardDetailMoreViewController in
            let moreViewModel = CardDetailMoreViewModel(id: self.cardID,
                                                        delegate: viewModel)
            let moreView = CardDetailMoreView(viewModel: moreViewModel, parent: viewController)
            let pageSheetController = PageSheetController(contentView: moreView)
            return pageSheetController
        }
        
        viewController.cardEditViewControllerFactory = { cardID -> CardInfoInputViewController in
            let dependencyContainer = CardInfoInputDependencyContainer(cardID: cardID)
            return dependencyContainer.createCardInfoInputViewController()
        }
        return viewController
    }
    
    private func createNameCardDetailViewModel() -> NameCardDetailViewModel {
        let cardRepository = self.createCardRepository()
        let clipboardService = self.createClipboardService()
        return NameCardDetailViewModel(cardID: cardID,
                                       cardRepository: cardRepository,
                                       myCardRepository: self.createMyCardRepository(),
                                       clipboardService: clipboardService,
                                       questRepository: YourNameQuestRepository())
    }
    
    private func createCardRepository() -> CardRepository {
        return YourNameCardRepository()
    }
    
    private func createClipboardService() -> ClipboardService {
        return YourNameClipboardService()
    }
    
    private func createMyCardRepository() -> MyCardRepository {
        return YourNameMyCardRepository()
    }
}
