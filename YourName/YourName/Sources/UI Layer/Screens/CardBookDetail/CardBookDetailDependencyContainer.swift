//
//  CardBookDependencyContainer.swift
//  YourName
//
//  Created by seori on 2021/10/04.
//

import UIKit

final class CardBookDetailDependencyContainer {
    
    init(cardBookListDependencyContainer: CardBookListDependencyContainer) {
        
    }
    
    func createCardBookDetailViewController(cardBookID: CardBookID?, cardBookTitle: String?, state: CardBookDetailViewModel.State = .normal) -> CardBookDetailViewController {
        let viewController = CardBookDetailViewController.instantiate()
        let viewModel = createCardBookDetailViewModel(cardBookID: cardBookID, cardBookTitle: cardBookTitle, state: state)
        viewController.viewModel = viewModel
        
        viewController.nameCardDetailViewControllerFactory = { cardBookID, cardId, uniqueCode in
            let dependencyContainer = self.createCardDetailDependencyContainer(cardBookID: cardBookID, cardId: cardId, uniqueCode: uniqueCode)
            return dependencyContainer.createNameCardDetailViewController()
        }
        viewController.cardBookMoreViewControllerFactory = { cardBookName, isCardEmpty in
            let viewModel = CardBookMoreViewModel(
                cardBookName: cardBookName,
                isCardEmpty: isCardEmpty,
                delegate: viewModel
            )
            let contentView = CardBookMoreView(
                viewModel: viewModel,
                parent: viewController
            )
            return PageSheetController(contentView: contentView)
        }
        viewController.allCardBookDetailViewControllerFactory = { [weak self] cardBookId in
            guard let self = self else { fatalError() }
            return self.createCardBookDetailViewController(cardBookID: nil, cardBookTitle: "전체도감", state: .migrate(cardBookId: cardBookId))
        }
        
        viewController.editCardBookViewControllerFactory = { [weak self] cardBookId in
            guard let self = self else { fatalError() }
            return self.createEditCardBookDependencyContainer(cardBookId: cardBookId).createAddCardBookViewController()
        }
        return viewController
    }
    
    private func createCardBookDetailViewModel(cardBookID: CardBookID?,
                                               cardBookTitle: String?,
                                               state: CardBookDetailViewModel.State) -> CardBookDetailViewModel {
        let cardRepository = createCardRepository()
        return CardBookDetailViewModel(cardBookID: cardBookID,
                                       cardBookTitle: cardBookTitle,
                                       cardRepository: cardRepository,
                                       cardBookrepository: YourNameCardBookRepository(),
                                       state: state)
    }
    
    private func createCardRepository() -> CardRepository {
        return YourNameCardRepository()
    }
    
    private func createCardDetailDependencyContainer(cardBookID: CardBookID?, cardId: Identifier, uniqueCode: UniqueCode) -> NameCardDetailDependencyContainer {
        return NameCardDetailDependencyContainer(
            cardId: cardId,
            uniqueCode: uniqueCode,
            cardBookDetailDependencyContainer: self,
            cardBookID: cardBookID
        )
    }
    
    private func createEditCardBookDependencyContainer(cardBookId: CardBookID) -> AddCardBookDependencyContainer {
        return AddCardBookDependencyContainer(mode: .edit(cardBookId: cardBookId))
    }
}
