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
    
    func createQuestViewController() -> QuestViewController {
        let viewController = QuestViewController.instantiate()
        let viewModel = self.createQuestViewModel()
        viewController.viewModel = viewModel
        return viewController
    }
    
    private func createQuestViewModel() -> QuestViewModel {
        let repository = self.createQuestRepository()
        return QuestViewModel(questRepository: repository)
    }
    
    private func createQuestRepository() -> QuestRepository {
        return MockQuestRepository()
    }
}
