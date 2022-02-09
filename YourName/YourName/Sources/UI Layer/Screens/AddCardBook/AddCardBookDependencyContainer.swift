//
//  AddCardBookDependencyContainer.swift
//  MEETU
//
//  Created by Seori on 2022/02/08.
//

import Foundation
import UIKit

final class AddCardBookDependencyContainer {
    init() {
        
    }
    
    func createAddCardBookViewController() -> UIViewController {
        let viewController = AddCardBookViewController.instantiate()
        let colorRepository = YourNameColorRepository()
        let cardBookRepository = YourNameCardBookRepository()
        let viewModel = AddCardBookViewModelImp(
            colorRepository: colorRepository,
            cardBookRepository: cardBookRepository
        )
        viewController.viewModel = viewModel
        
        return viewController
    }
}
