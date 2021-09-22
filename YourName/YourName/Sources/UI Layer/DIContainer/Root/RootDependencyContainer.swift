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
        #warning("⚠️ TODO: FakeAccessTokenRepository를 나중에 실제 오브젝트로 대체해야합니다.") // Booung
        self.rootViewModel = RootViewModel()
        let fakeAccessTokenRepository = FakeAccessTokenRepository()
        // fakeAccessTokenRepository.hasAccessToken = false
        // hasAccessToken - 신규로그인의 경우에는 true, 자동로그인의 경우에는 false로 테스트할 수 있습니다.
        self.accessTokenRepository = fakeAccessTokenRepository
    }
    
    // Root Factory
    func createRootViewController() -> RootViewController {
        return RootViewController(
            viewModel: rootViewModel,
            splashViewControllerFactory: createSplashViewController,
            signInViewControllerFactory: createSignInViewController,
            homeTabBarControllerFactory: createHomeTabBarController(accessToken:)
        )
    }
    
    // Splash Factory
    private func createSplashViewController() -> SplashViewController {
        let viewModel = createSplashViewModel()
        return SplashViewController(viewModel: viewModel)
    }
    
    private func createSplashViewModel() -> SplashViewModel {
        return SplashViewModel(
            accessTokenRepository: accessTokenRepository,
            authenticationDelegate: rootViewModel)
    }
    
    // SignIn Factory
    private func createSignInViewController() -> SignInViewController {
        let signInViewModel = createSignInViewModel()
        return SignInViewController(viewModel: signInViewModel)
    }
    
    private func createSignInViewModel() -> SignInViewModel {
        return SignInViewModel()
    }
    
    // SignedInDependencyContainer Factory
    private func createSignedInDependencyContainer(with accessToken: AccessToken) -> SignedInDependencyContainer {
        return SignedInDependencyContainer(rootDependencyContainer: self, accessToken: accessToken)
    }
    
    private func createHomeTabBarController(accessToken: AccessToken) -> HomeTabBarController {
        return createSignedInDependencyContainer(with: accessToken).createHomeViewController()
    }
     
    // SignedOutDependencyContainer Factory
    private func createSignedOutDependencyContainer() -> SignedOutDependencyContainer {
        return SignedOutDependencyContainer(rootDependencyContainer: self)
    }
    
}
