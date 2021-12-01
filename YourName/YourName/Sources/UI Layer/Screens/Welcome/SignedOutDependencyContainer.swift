//
//  SignedOutDependencyContainer.swift
//  YourName
//
//  Created by Booung on 2021/09/18.
//

import Foundation

final class SignedOutDependencyContainer {
    
    let rootViewModel: RootViewModel
    let authenticationRepository: AuthenticationRepository
    
    init(rootDependencyContainer: RootDependencyContainer) {
        self.rootViewModel = rootDependencyContainer.rootViewModel
        self.authenticationRepository = rootDependencyContainer.authenticationRepository
    }
    
    func createWelcomeViewController() -> WelcomeViewController {
        let viewController = WelcomeViewController.instantiate()
        viewController.viewModel = createWelcomeViewModel()
        return viewController
    }
    
    private func createWelcomeViewModel() -> WelcomeViewModel {
        let oauthRepository = YourNameOAuthRepository()
        return WelcomeViewModel(delegate: rootViewModel,
                                authenticationRepository: authenticationRepository,
                                oauthRepository: oauthRepository,
                                localStorage: UserDefaults.standard)
    }
}
