//
//  AppContainer.swift
//  YourName
//
//  Created by Booung on 2021/09/18.
//

import Foundation

final class RootDependencyContainer {
    
    let rootViewModel: RootViewModel
    let accessTokenRepository: AccessTokenRepository
    
    init() {
//        #warning("⚠️ TODO: FakeAccessTokenRepository를 나중에 실제 오브젝트로 대체해야합니다.") // Booung
        self.rootViewModel = RootViewModel()
        let kakaoAccessTokenRepository = KakaoAccessTokenRepository()
        // fakeAccessTokenRepository.hasAccessToken = false
        // hasAccessToken - 신규로그인의 경우에는 true, 자동로그인의 경우에는 false로 테스트할 수 있습니다.
        self.accessTokenRepository = kakaoAccessTokenRepository
    }
    
    // Root Factory
    func createRootViewController() -> RootViewController {
        let splashViewControllerFactory: () -> SplashViewController = {
            self.createSplashViewController()
        }
        let signInViewControllerFactory: () -> SignInViewController = {
            let dependencyContainer = self.createSignedOutDependencyContainer()
            return dependencyContainer.createSignInViewController()
        }
        let homeTabBarControllerFactory: (AccessToken) -> HomeTabBarController = { accessToken in
            let dependencyContainer = self.createSignedInDependencyContainer(accessToken: accessToken)
            return dependencyContainer.createHomeViewController()
        }
        
        return RootViewController(
            viewModel: rootViewModel,
            splashViewControllerFactory: splashViewControllerFactory,
            signInViewControllerFactory: signInViewControllerFactory,
            homeTabBarControllerFactory: homeTabBarControllerFactory
        )
    }
    
    // Splash Factory
    private func createSplashViewController() -> SplashViewController {
        let viewModel = SplashViewModel(
            accessTokenRepository: accessTokenRepository,
            authenticationDelegate: rootViewModel
        )
        return SplashViewController(viewModel: viewModel)
    }
    
    // Child Dependency Container Factory
    private func createSignedInDependencyContainer(accessToken: AccessToken) -> SignedInDependencyContainer {
        return SignedInDependencyContainer(accessToken: accessToken, rootDependencyContainer: self)
    }
    
    private func createSignedOutDependencyContainer() -> SignedOutDependencyContainer {
        return SignedOutDependencyContainer(rootDependencyContainer: self)
    }
    
}
