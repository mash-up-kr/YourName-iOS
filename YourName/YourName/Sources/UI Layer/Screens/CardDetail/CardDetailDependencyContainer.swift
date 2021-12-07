//
//  CardDetailDependencyContainer.swift
//  YourName
//
//  Created by Booung on 2021/09/21.
//

import UIKit

final class CardDetailDependencyContainer {
    
    let cardID: Identifier
    let myCardRepository: MyCardRepository
    
    init(
        cardID: Identifier,
        myCardListDependencyContainer: MyCardListDependencyContainer,
        myCardRepository: MyCardRepository
    ) {
        // do something
        // get state of myCardListDependencyContainer
        self.cardID = cardID
        self.myCardRepository = myCardRepository
    }
    
    init(cardID: Identifier) {
        self.cardID = cardID
        self.myCardRepository = YourNameMyCardRepository()
    }
    
    func createCardDetailViewController() -> CardDetailViewController {
        let viewModel = createCardDetailViewModel()
        let viewController = CardDetailViewController.instantiate()
        viewController.viewModel = viewModel
        
        // MARK: cardDetailMoreViewFactory
        viewController.cardDetailMoreViewFactory = { cardID -> CardDetailMoreViewController in
            let _viewModel = CardDetailMoreViewModel(id: self.cardID,
                                                     delegate: viewModel)
            let view = CardDetailMoreView(viewModel: _viewModel,
                                          parent: viewController)
            
            let pageSheetController = PageSheetController(contentView: view)
            return pageSheetController
        }
        
        // MARK: cardDetailMoreViewFactory
        viewController.cardEditViewFactory = { cardID -> CardCreationViewController in
            let viewModel = CardCreationViewModel(myCardRepsitory: self.myCardRepository, imageUploader:  YourNameImageUploader())
            let viewController = CardCreationViewController.instantiate()
            viewController.viewModel = viewModel
            
            return viewController
        }
        
        
        return viewController
    }
    
    private func createCardDetailViewModel() -> CardDetailViewModel {
        return CardDetailViewModel(cardID: cardID,
                                   repository: self.myCardRepository)
    }
}
