//
//  AddCardBookDependencyContainer.swift
//  MEETU
//
//  Created by Seori on 2022/02/08.
//

import Foundation
import UIKit

final class AddCardBookDependencyContainer {
    
    enum Mode {
        case create
        case edit(cardBookId: CardBookID)
    }
    
    private let mode: Mode
    init(mode: Mode = .create) {
        self.mode = mode
    }
    
    func createAddCardBookViewController() -> AddCardBookViewController {
        let viewController = AddCardBookViewController.instantiate()
        let colorRepository = YourNameColorRepository()
        let cardBookRepository = YourNameCardBookRepository()
        let viewModel = AddCardBookViewModelImp(
            colorRepository: colorRepository,
            cardBookRepository: cardBookRepository,
            mode: self.mode
        )
        viewController.viewModel = viewModel
        
        return viewController
    }
}
