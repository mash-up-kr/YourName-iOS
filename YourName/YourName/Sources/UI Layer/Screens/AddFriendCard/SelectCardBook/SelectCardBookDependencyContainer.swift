//
//  SelectCardBookDependencyContainer.swift
//  MEETU
//
//  Created by Seori on 2022/03/05.
//

import Foundation

final class SelectCardBookDependencyContainer {
    
    deinit {
        print("💀 \(String(describing: self)) deinit")
    }
    
    func createSelectCardBookViewController() -> SelectCardBookViewController {
        let viewController = SelectCardBookViewController.instantiate()
        let cardDetailVieWControllerFactory: (UniqueCode, Identifier) -> NameCardDetailViewController = { uniqueCode, nameCardId  in
            let dependencyContainer = self.createNameCardDetailDependencyContainer(cardId: nameCardId, uniqueCode: uniqueCode)
            return dependencyContainer.createNameCardDetailViewController()
        }
        let viewModel = SelectCardBookViewModel(cardBookRepository: YourNameCardBookRepository())
        viewController.viewModel = viewModel
        viewController.cardDetailViewControllerFactory = cardDetailVieWControllerFactory
        return viewController
    }
    
    private func createNameCardDetailDependencyContainer(cardId: Identifier, uniqueCode: UniqueCode) -> NameCardDetailDependencyContainer {
        NameCardDetailDependencyContainer(cardId: cardId, uniqueCode: uniqueCode)
    }
}
