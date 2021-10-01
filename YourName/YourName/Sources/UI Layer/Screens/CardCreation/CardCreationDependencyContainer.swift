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
        viewContorller.characterCreationViewControllerFactory = {
            let dependencyContainer = self.createCharacterItemDependencyContainer()
            return dependencyContainer.createCharacterCreationViewController()
        }
        return viewContorller
    }
    
    // Child
    private func createCharacterItemDependencyContainer() -> CharacterCreationDependencyContainer {
        return CharacterCreationDependencyContainer(cardCreationDependencyContainer: self)
    }
}
