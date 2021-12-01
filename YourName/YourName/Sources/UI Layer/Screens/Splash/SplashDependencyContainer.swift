//
//  SplashDependencyContainer.swift
//  YourName
//
//  Created by Booung on 2021/10/03.
//

import Foundation

final class SplashDependencyContainer {
    
    let rootViewModel: RootViewModel
    let authenticationRepository: AuthenticationRepository
    
    init(rootDependencyContainer: RootDependencyContainer) {
        self.rootViewModel = rootDependencyContainer.rootViewModel
        self.authenticationRepository = rootDependencyContainer.authenticationRepository
    }
    
    func createSplashViewController() -> SplashViewController {
        let viewController = SplashViewController.instantiate()
        viewController.viewModel = createSplashViewModel()
        return viewController
    }
    
    private func createSplashViewModel() -> SplashViewModel {
        let viewModel = SplashViewModel(
            authenticationRepository: authenticationRepository,
            authenticationDelegate: rootViewModel
        )
        return viewModel
    }
    
}
