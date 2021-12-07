//
//  QuestDepencyContainer.swift
//  MEETU
//
//  Created by Booung on 2021/11/25.
//

import Foundation

final class QuestDependencyContainer {
    
    init(settingDependencyContainer: SettingDependencyContainer) {
        
    }
    init() {
        
    }
    
    func createQuestViewController() -> QuestViewController {
        let viewController = QuestViewController.instantiate()
        let viewModel = self.createQuestViewModel()
        viewController.viewModel = viewModel
        return viewController
    }
    
    private func createQuestViewModel() -> QuestViewModel {
        let useCase = self.createQuestUseCase()
        return QuestViewModel(questUseCase: useCase)
    }
    
    private func createQuestUseCase() -> QuestUseCase {
        let repository = self.createQuestRepository()
        return YourNameQuestUseCase(questRepository: repository)
    }
    
    private func createQuestRepository() -> QuestRepository {
        return YourNameQuestRepository()
    }
    
}
