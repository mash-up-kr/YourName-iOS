//
//  CardBookDependencyContainer.swift
//  MEETU
//
//  Created by USER on 2021/10/28.
//

import UIKit

final class CardBookDependencyContainer {
    
    init(signedInDependencyContainer: SignedInDependencyContainer) {
        
    }
    
    func createCardBookViewController() -> UIViewController {
        let viewController = CardBookViewController.instantiate()
        let viewModel = createCardBookViewModel()
        viewController.viewModel = viewModel
        let naviController = UINavigationController(rootViewController: viewController)
        naviController.navigationBar.isHidden = true
        return naviController
    }
    
    private func createCardBookViewModel() -> CardBookViewModel {
        let cardBookRepository = createCardBookRepository()
        return CardBookViewModel(cardBookRepository: cardBookRepository)
    }
    
    private func createCardBookRepository() -> CardBookRepository {
        return MockCardBookRepository()
    }
}
