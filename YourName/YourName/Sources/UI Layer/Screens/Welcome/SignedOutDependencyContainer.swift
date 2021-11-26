//
//  SignedOutDependencyContainer.swift
//  YourName
//
//  Created by Booung on 2021/09/18.
//

import Foundation

final class SignedOutDependencyContainer {
    
    let rootViewModel: RootViewModel
    
    init(rootDependencyContainer: RootDependencyContainer) {
        self.rootViewModel = rootDependencyContainer.rootViewModel
    }
    
    func createWelcomeViewController() -> WelcomeViewController {
        let viewController = WelcomeViewController.instantiate()
        viewController.viewModel = createWelcomeViewModel()
        return viewController
    }
    
    private func createWelcomeViewModel() -> WelcomeViewModel {
        let authRepository = YourNameAuthRepository()
        let OAuthRepository = YourNameOAuthRepository()
        return WelcomeViewModel(delegate: rootViewModel,
                                authRepository: authRepository,
                                OAuthRepository: OAuthRepository)
    }
}
