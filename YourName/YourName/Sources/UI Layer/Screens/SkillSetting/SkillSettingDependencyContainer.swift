//
//  SkillSettingDependencyContainer.swift
//  YourName
//
//  Created by Booung on 2021/10/02.
//

import Foundation



final class SkillSettingDependencyContainer {
    
    let cardCreationViewModel: CardInfoInputViewModel
    let skills: [Skill]
    
    init(skills: [Skill], cardCreationDependencyContainer: CardInfoInputDependencyContainer) {
        self.skills = skills
        self.cardCreationViewModel = cardCreationDependencyContainer.viewModel
    }
    
    func createSkillSettingViewController() -> SkillSettingViewController {
        let view = createSkillSettingView()
        return PageSheetController(contentView: view)
    }
    
    private func createSkillSettingView() -> SkillSettingView {
        let view = SkillSettingView()
        view.viewModel = createSkillSettingViewModel()
        return view
    }
    
    private func createSkillSettingViewModel() -> SkillSettingViewModel {
        return SkillSettingViewModel(skills: self.skills, skillSettingResponder: cardCreationViewModel)
    }
}
