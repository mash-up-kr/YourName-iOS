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
    
    init(mycardListDependencyContainer: MyCardListDependencyContainer) {
        
    }
    
    func settingViewController() -> UIViewController {
        let viewModel = SettingViewModel()
        let viewController = SettingViewController.instantiate()
        viewController.viewModel = viewModel
        
        let aboutProductionTeamFactory: () -> AboutProductionTeamViewController = {
            return AboutProductionTeamViewController.instantiate()
        }
        
        viewController.aboutProductionTeamFactory = aboutProductionTeamFactory
      
        let navigationController = UINavigationController(rootViewController: viewController)
        return navigationController
    }
}
