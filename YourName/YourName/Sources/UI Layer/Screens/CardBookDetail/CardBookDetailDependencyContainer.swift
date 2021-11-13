//
//  CardBookDependencyContainer.swift
//  YourName
//
//  Created by seori on 2021/10/04.
//

import Foundation
import UIKit

final class CardBookDetailDependencyContainer {
    
    init(cardBookListDependencyContainer: CardBookListDependencyContainer) {
        
    }
    
    func createCardBookDetailViewController(cardBookID: String) -> UIViewController {
        let viewController = CardBookDetailViewController.instantiate()
        let viewModel = createCardBookDetailViewModel()
        viewController.viewModel = viewModel
        return viewController
    }
    
    private func createCardBookDetailViewModel() -> CardBookDetailViewModel {
        let cardRepository = MockCardRepository()
        return CardBookDetailViewModel(cardRepository: cardRepository)
    }
}
