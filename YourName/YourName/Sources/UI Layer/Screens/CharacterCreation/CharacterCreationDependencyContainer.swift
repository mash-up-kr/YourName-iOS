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
    
    init(cardCreationDependencyContainer: CardInfoInputDependencyContainer) {
        func createCharacterItemRepository() -> CharacterItemRepository {
            return YourNameCharacterItemRepository(factory: YourNameCharacterItemFactory())
        }
        
        func createCharaterSettingViewModel(
            characterItemRepository: CharacterItemRepository,
            cardCreationViewModel: CardInfoInputViewModel
        ) -> CharacterSettingViewModel {
            return CharacterSettingViewModel(
                characterItemRepository: characterItemRepository,
                characterSettingResponder: cardCreationViewModel
            )
        }
        
        let cardCreationViewModel = cardCreationDependencyContainer.viewModel
        self.characterItemRepository = createCharacterItemRepository()
        self.characterSettingViewModel = createCharaterSettingViewModel(characterItemRepository: self.characterItemRepository,
                                                                        cardCreationViewModel: cardCreationViewModel)
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
