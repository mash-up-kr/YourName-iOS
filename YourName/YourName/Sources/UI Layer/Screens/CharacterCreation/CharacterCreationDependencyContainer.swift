//
//  CharacterCreationDependencyContainer.swift
//  YourName
//
//  Created by Booung on 2021/10/02.
//

import Foundation

final class CharacterCreationDependencyContainer {
    
    let characterSettingViewModel: CharacterSettingViewModel
    let characterItemRepository: CharacterItemRepository
    
    init(cardCreationDependencyContainer: CardCreationDependencyContainer) {
        func createCharacterItemRepository() -> CharacterItemRepository {
            return CharacterItemRepositoryImpl(factory: CharacterItemFactoryImpl())
        }
        
        func createCharaterSettingViewModel(_ characterItemRepository: CharacterItemRepository) -> CharacterSettingViewModel {
            return CharacterSettingViewModel(characterItemRepository: characterItemRepository)
        }
        
        self.characterItemRepository = createCharacterItemRepository()
        self.characterSettingViewModel = createCharaterSettingViewModel(self.characterItemRepository)
    }
    
    func createCharacterSettingViewController() -> CharacterSettingViewController {
        let view = CharacterSettingView()
        view.displayCharacterItemsViewControllerFactory = { categories in
            let dependencyContainer = self.createDisplayCharacterItemsDependencyContainer()
            return dependencyContainer.createDisplayCharacterItemsViewControllers(of: categories)
        }
        view.viewModel = characterSettingViewModel
        return PageSheetController(contentView: view)
    }
    
    // 👼 Child DependencyContainer
    private func createDisplayCharacterItemsDependencyContainer() -> DisplayCharacterItemsDependencyContainer {
        return DisplayCharacterItemsDependencyContainer(characterCreationDependencyContainer: self)
    }
    
}
