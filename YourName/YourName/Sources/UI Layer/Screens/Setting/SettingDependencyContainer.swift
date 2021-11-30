//
//  SettingDependencyContainer.swift
//  YourName
//
//  Created by 송서영 on 2021/10/09.
//

import UIKit

final class SettingDependencyContainer {
    
    init(signedInDependencyContainer: SignedInDependencyContainer) {
        
    }
    
    func settingViewController() -> UIViewController {
        let viewController = SettingViewController.instantiate()
        viewController.viewModel = self.createSettingViewModel()
        
        let aboutProductionTeamFactory: () -> AboutProductionTeamViewController = {
            return AboutProductionTeamViewController.instantiate()
        }
        
        viewController.aboutProductionTeamFactory = aboutProductionTeamFactory
        viewController.questViewControllerFactory = {
            let depencyContainer = self.createQuestDependencyContainer()
            return depencyContainer.createQuestViewController()
        }
      
        let navigationController = UINavigationController(rootViewController: viewController)
        return navigationController
    }
    
    private func createQuestDependencyContainer() -> QuestDependencyContainer {
        return QuestDependencyContainer(settingDependencyContainer: self)
    }
    
    private func createSettingViewModel() -> SettingViewModel {
        return SettingViewModel(authRepository: YourNameAuthRepository())
    }
}
