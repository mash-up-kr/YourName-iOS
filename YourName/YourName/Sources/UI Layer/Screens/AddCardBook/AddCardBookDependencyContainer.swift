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
        let viewModel = self.createViewModel(with: self.mode)
        viewController.viewModel = viewModel
        
        return viewController
    }
    
    private func createViewModel(with mode: Mode) -> CreateCardBookViewModelType {
        let colorRepository = YourNameColorRepository()
        let cardBookRepository = YourNameCardBookRepository()
        switch mode {
        case .create:
            return AddCardBookViewModel(
                colorRepository: colorRepository,
                cardBookRepository: cardBookRepository
            )
        case .edit(let cardBookID):
            return EditCardBookViewModel(
                colorRepository: colorRepository,
                cardBookRepository: cardBookRepository,
                cardBookID: cardBookID
            )
        }
    }
}
