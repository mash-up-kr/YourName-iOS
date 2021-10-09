//
//  SettingDependencyContainer.swift
//  YourName
//
//  Created by seori on 2021/10/09.
//

import UIKit

final class SettingDependencyContainer {
    
    func settingViewController() -> UIViewController {
        let viewModel = SettingViewModel()
        let viewController = SettingViewController.instantiate()
        viewController.viewModel = viewModel
        let navigationController = UINavigationController(rootViewController: viewController)
        return navigationController
    }
}
