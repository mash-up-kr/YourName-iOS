//
//  DisplayCharacterItemsDependencyContainer.swift
//  YourName
//
//  Created by Booung on 2021/10/06.
//

import Foundation

final class DisplayCharacterItemsDependencyContainer {
    
    let displayCharacterItemsResponder: DisplayCharacterItemsResponder
    let characterItemRepository: CharacterItemRepository
    
    init(characterCreationDependencyContainer: CharacterCreationDependencyContainer) {
        self.displayCharacterItemsResponder = characterCreationDependencyContainer.characterSettingViewModel
        self.characterItemRepository = characterCreationDependencyContainer.characterItemRepository
    }
    
    func createDisplayCharacterItemsViewControllers(of categories: [ItemCategory] = ItemCategory.allCases) -> [DisplayCharacterItemsViewController] {
        return categories.map { createDisplayCharacterItemsViewController(category: $0) }
    }
    
    private func createDisplayCharacterItemsViewController(category: ItemCategory) -> DisplayCharacterItemsViewController {
        let viewController = DisplayCharacterItemsViewController.instantiate()
        viewController.viewModel = createDisplayCharacterItemsViewModel(category: category)
        return viewController
    }
    
    private func createDisplayCharacterItemsViewModel(category: ItemCategory) -> DisplayCharacterItemsViewModel {
        DisplayCharacterItemsViewModel(category: category, characterItemRepository: characterItemRepository, displayCharacterItemsResponder: displayCharacterItemsResponder)
    }
}
