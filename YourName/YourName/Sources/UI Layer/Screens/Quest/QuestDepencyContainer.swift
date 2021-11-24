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
        return viewController
    }
}
