//
//  CharacterCreationDependencyContainer.swift
//  YourName
//
//  Created by Booung on 2021/10/02.
//

import Foundation

final class CharacterCreationDependencyContainer {
    
    init(cardCreationDependencyContainer: CardCreationDependencyContainer) {
        
    }
    
    func createCharacterCreationViewController() -> CharacterCreationViewController {
        let characterItemRepository = createCharacterItemRepository()
        let viewModel = CharacterCreationViewModel(characterItemRepository: characterItemRepository)
        let viewController = CharacterCreationViewController.instantiate()
        viewController.viewModel = viewModel
        return viewController
    }
    
    private func createCharacterItemRepository() -> CharacterItemRepository {
        return FakeCharacterItemRepository()
    }
}
