//
//  SplashDependencyContainer.swift
//  YourName
//
//  Created by Booung on 2021/10/03.
//

import Foundation

final class SplashDependencyContainer {
    
    let rootViewModel: RootViewModel
    let accessTokenRepository: AccessTokenRepository
    
    init(rootDependencyContainer: RootDependencyContainer) {
        self.rootViewModel = rootDependencyContainer.rootViewModel
        self.accessTokenRepository = rootDependencyContainer.accessTokenRepository
    }
    
    func createSplashViewController() -> SplashViewController {
        let viewController = SplashViewController.instantiate()
        viewController.viewModel = createSplashViewModel()
        return viewController
    }
    
    private func createSplashViewModel() -> SplashViewModel {
        let viewModel = SplashViewModel(
            accessTokenRepository: accessTokenRepository,
            authenticationDelegate: rootViewModel
        )
        return viewModel
    }
    
}
