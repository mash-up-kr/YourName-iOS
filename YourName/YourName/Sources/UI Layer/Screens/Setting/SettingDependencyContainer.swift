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
    
    deinit {
        print(" 💀 \(String(describing: self)) deinit")
    }
    
    func settingViewController() -> UIViewController {
        let viewController = SettingViewController.instantiate()
        viewController.viewModel = self.createSettingViewModel()
        
        let aboutProductionTeamFactory: () -> AboutProductionTeamViewController = {
            return AboutProductionTeamViewController.instantiate()
        }
        
        viewController.aboutProductionTeamFactory = aboutProductionTeamFactory
        viewController.questViewControllerFactory = {
            let depencyContainer = QuestDependencyContainer(settingDependencyContainer: self)
            return depencyContainer.createQuestViewController()
        }
        
        viewController.noticeViewControllerFactory = {
            let viewController = NoticeViewController.instantiate()
            return viewController
        }
      
        let navigationController = UINavigationController(rootViewController: viewController)
        return navigationController
    }
    
    private func createSettingViewModel() -> SettingViewModel {
        return SettingViewModel(authRepository: YourNameAuthRepository())
    }
}
