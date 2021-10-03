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
            let dependencyContainer = self.createCharacterCreationDependencyContainer()
            return dependencyContainer.createCharacterCreationViewController()
        }
        viewContorller.palettePageSheetControllerFactory = {
            let dependencyContainer = self.createPaletteDependencyContainer()
            return dependencyContainer.createPalettePageSheetController()
        }
        viewContorller.tmiSettingViewControllerFactory = {
            let dependencyContainer = self.createTMISettingDependencyContainer()
            return dependencyContainer.createTMISettingViewController()
        }
        viewContorller.skillSettingViewControllerFactory = {
            let dependencyContainer = self.createSkillSettingDependencyContainer()
            return dependencyContainer.createSkillSettingViewController()
        }
        return viewContorller
    }
    
    // 👼 Child Dependency Container
    private func createCharacterCreationDependencyContainer() -> CharacterCreationDependencyContainer {
        return CharacterCreationDependencyContainer(cardCreationDependencyContainer: self)
    }
    
    private func createPaletteDependencyContainer() -> PaletteDependencyContainer {
        return PaletteDependencyContainer(cardCreationDependencyContainer: self)
    }
    
    private func createTMISettingDependencyContainer() -> TMISettingDependencyContainer {
        return TMISettingDependencyContainer(cardCreationDependencyContainer: self)
    }
    
    private func createSkillSettingDependencyContainer() -> SkillSettingDependencyContainer {
        return SkillSettingDependencyContainer(cardCreationDependencyContainer: self)
    }
    
}
