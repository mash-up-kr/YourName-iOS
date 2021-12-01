//
//  CreateCardDependencyContainer.swift
//  YourName
//
//  Created by Booung on 2021/09/30.
//

import Foundation

final class CardCreationDependencyContainer {
    
    let viewModel: CardCreationViewModel
    
    init(myCardListDependencyContainer: MyCardListDependencyContainer) {
        func createCardCreationViewModel() -> CardCreationViewModel {
            let repository = YourNameMyCardRepository()
            let imageUploader = YourNameImageUploader()
            return CardCreationViewModel(myCardRepsitory: repository,
                                         imageUploader: imageUploader)
        }
        
        self.viewModel = createCardCreationViewModel()
    }
    
    func createCardCreationViewController() -> CardCreationViewController {
        let viewContorller = CardCreationViewController.instantiate()
        viewContorller.viewModel = viewModel
        viewContorller.imageSourceTypePickerViewControllerFactory = {
            let dependencyContainer = self.createImageSourceDependencyContainer()
            return dependencyContainer.createImageSourcePickerViewController()
        }
        viewContorller.characterSettingViewControllerFactory = {
            let dependencyContainer = self.createCharacterCreationDependencyContainer()
            return dependencyContainer.createCharacterSettingViewController()
        }
        viewContorller.paletteViewControllerFactory = {
            let dependencyContainer = self.createPaletteDependencyContainer()
            return dependencyContainer.createPaletteViewController()
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
    
    private func createImageSourceDependencyContainer() -> ImageSourceTypePickerDependencyContainer {
        return ImageSourceTypePickerDependencyContainer(cardCreationDependencyContainer: self)
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
