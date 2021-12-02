//
//  AppContainer.swift
//  YourName
//
//  Created by Booung on 2021/09/18.
//

import Foundation

final class RootDependencyContainer {
    
    let rootViewModel: RootViewModel
    let authenticationRepository: AuthenticationRepository
    
    init() {
        self.rootViewModel = RootViewModel()
        self.authenticationRepository = YourNameAuthenticationRepository(
            localStorage: UserDefaults.standard,
            network: Environment.current.network
        )
        (Environment.current.network as? NetworkService)?.authenticationRepository = self.authenticationRepository
    }
    
    func createRootViewController() -> RootViewController {
        let splashViewControllerFactory: () -> SplashViewController = {
            let dependencyContainer = self.createSplashDependencyContainer()
            return dependencyContainer.createSplashViewController()
        }
        let signInViewControllerFactory: () -> WelcomeViewController = {
            let dependencyContainer = self.createSignedOutDependencyContainer()
            return dependencyContainer.createWelcomeViewController()
        }
        let homeTabBarControllerFactory: (Secret, Secret) -> HomeTabBarController = { accessToken, refreshToken in
            let dependencyContainer = self.createSignedInDependencyContainer(accessToken: accessToken, refreshToken: refreshToken)
            return dependencyContainer.createHomeViewController()
        }
        
        return RootViewController(
            viewModel: rootViewModel,
            splashViewControllerFactory: splashViewControllerFactory,
            signInViewControllerFactory: signInViewControllerFactory,
            homeTabBarControllerFactory: homeTabBarControllerFactory
        )
    }
    
    // 👼 Child Dependency Container
    private func createSplashDependencyContainer() -> SplashDependencyContainer {
        return SplashDependencyContainer(rootDependencyContainer: self)
    }
    
    private func createSignedInDependencyContainer(accessToken: Secret, refreshToken: Secret) -> SignedInDependencyContainer {
        return SignedInDependencyContainer(accessToken: accessToken, refreshToken: refreshToken, rootDependencyContainer: self)
    }
    
    private func createSignedOutDependencyContainer() -> SignedOutDependencyContainer {
        return SignedOutDependencyContainer(rootDependencyContainer: self)
    }
    
}
