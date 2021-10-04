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
    
    func createCharacterSettingViewController() -> CharacterSettingViewController {
        let view = CharacterSettingView()
        view.viewModel = createCharaterSettingViewModel()
        return PageSheetController(contentView: view)
    }
    
    private func createCharaterSettingViewModel() -> CharacterSettingViewModel {
        let repository = createCharacterItemRepository()
        return CharacterSettingViewModel(characterItemRepository: repository)
    }
    
    private func createCharacterItemRepository() -> CharacterItemRepository {
        return FakeCharacterItemRepository()
    }
}
