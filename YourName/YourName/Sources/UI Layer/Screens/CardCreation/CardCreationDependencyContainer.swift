//
//  CreateCardDependencyContainer.swift
//  YourName
//
//  Created by Booung on 2021/09/30.
//

import Foundation

final class CardCreationDependencyContainer {
    
    init(myCardListDependencyContainer: MyCardListDependencyContainer) {
        
    }
    
    func createCardCreationViewController() -> CardCreationViewController {
        let viewModel = CardCreationViewModel()
        let viewContorller = CardCreationViewController.instantiate()
        viewContorller.viewModel = viewModel
        return viewContorller
    }
}
