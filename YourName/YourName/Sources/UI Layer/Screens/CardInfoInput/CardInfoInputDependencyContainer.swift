//
//  CreateCardDependencyContainer.swift
//  YourName
//
//  Created by Booung on 2021/09/30.
//

import Foundation

final class CardInfoInputDependencyContainer {
    
    let viewModel: CardInfoInputViewModel
    
    init(myCardListDependencyContainer: MyCardListDependencyContainer) {
        func createCardInfoInputViewModel() -> CardInfoInputViewModel {
            let repository = YourNameMyCardRepository()
            let imageUploader = YourNameImageUploader()
            return CardInfoInputViewModel(state: .new,
                                          cardRepository: nil,
                                          myCardRepository: repository,
                                          imageUploader: imageUploader)
        }
        
        self.viewModel = createCardInfoInputViewModel()
    }
    
    func createCardInfoInputViewController() -> CardInfoInputViewController {
        let viewContorller = CardInfoInputViewController.instantiate()
        viewContorller.viewModel = viewModel
        viewContorller.imageSourceTypePickerViewControllerFactory = {
            let dependencyContainer = self.createImageSourceDependencyContainer()
            return dependencyContainer.createImageSourcePickerViewController()
        }
        viewContorller.characterSettingViewControllerFactory = {
            let dependencyContainer = self.createCharacterCreationDependencyContainer()
            return dependencyContainer.createCharacterSettingViewController()
        }
        viewContorller.paletteViewControllerFactory = { selectedColorID in
            let dependencyContainer = self.createPaletteDependencyContainer(selectedColorID: selectedColorID)
            return dependencyContainer.createPaletteViewController()
        }
        viewContorller.tmiSettingViewControllerFactory = { interests, strongPoints in
            let dependencyContainer = self.createTMISettingDependencyContainer(interests: interests, strongPoints: strongPoints)
            return dependencyContainer.createTMISettingViewController()
        }
        viewContorller.skillSettingViewControllerFactory = { skills in
            let dependencyContainer = self.createSkillSettingDependencyContainer(skills: skills)
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
    
    private func createPaletteDependencyContainer(selectedColorID: Identifier?) -> PaletteDependencyContainer {
        return PaletteDependencyContainer(selectedColorID: selectedColorID, cardCreationDependencyContainer: self)
    }
    
    private func createTMISettingDependencyContainer(
        interests: [Interest],
        strongPoints: [StrongPoint]
    ) -> TMISettingDependencyContainer {
        return TMISettingDependencyContainer(
            interests: interests,
            strongPoints: strongPoints,
            cardCreationDependencyContainer: self
        )
    }
    
    private func createSkillSettingDependencyContainer(skills: [Skill]) -> SkillSettingDependencyContainer {
        return SkillSettingDependencyContainer(skills: skills, cardCreationDependencyContainer: self)
    }
    
}
