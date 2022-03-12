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
    
    deinit { print("\(String(describing: self)) deinit") }
    
    func createCardBookDetailViewController(cardBookID: CardBookID?, cardBookTitle: String?) -> UIViewController {
        let viewController = CardBookDetailViewController.instantiate()
        let viewModel = createCardBookDetailViewModel(cardBookID: cardBookID, cardBookTitle: cardBookTitle)
        viewController.viewModel = viewModel
        viewController.nameCardDetailViewControllerFactory = { cardId, uniqueCode in
            let dependencyContainer = self.createCardDetailDependencyContainer(cardId: cardId, uniqueCode: uniqueCode)
            return dependencyContainer.createNameCardDetailViewController()
        }
        
        viewController.optionViewControllerFactory = { [weak self] cardBookID -> CardBookDetailOptionViewController in
            guard let self = self else { return .init(contentView: .init(frame: .zero)) }
            return self.createCardOptionViewController(cardBookID: cardBookID, cardBookTitle: cardBookTitle, parent: viewController)
        }
        return viewController
    }
    
    private func createCardBookDetailViewModel(cardBookID: CardBookID?,
                                               cardBookTitle: String?) -> CardBookDetailViewModel {
        let cardRepository = createCardRepository()
        return CardBookDetailViewModel(cardBookID: cardBookID,
                                       cardBookTitle: cardBookTitle,
                                       cardRepository: cardRepository,
                                       cardBookRepository: YourNameCardBookRepository())
    }
    
    private func createCardOptionViewController(cardBookID: CardBookID, cardBookTitle: String?, parent: CardBookDetailViewController) -> CardBookDetailOptionViewController {
        let viewModel = CardBookDetailOptionViewModel(cardBookID: cardBookID, delegate: parent.viewModel)
        let contentView = CardBookDetailOptionView(viewModel: viewModel, cardBookTitle: cardBookTitle ,parent: parent)
        let pageViewController = CardBookDetailOptionViewController(contentView: contentView)
        return pageViewController
    }
    
    private func createCardRepository() -> CardRepository {
        return YourNameCardRepository()
    }
    
    private func createCardDetailDependencyContainer(cardId: Identifier, uniqueCode: UniqueCode) -> NameCardDetailDependencyContainer {
        return NameCardDetailDependencyContainer(cardId: cardId, uniqueCode: uniqueCode, cardBookDetailDependencyContainer: self)
    }
}
