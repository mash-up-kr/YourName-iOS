//
//  AppContainer.swift
//  YourName
//
//  Created by Booung on 2021/09/18.
//

import Foundation

final class RootDependencyContainer {
    
    // Root Factory
    func createRootViewController() -> RootViewController {
        let rootViewModel = createRootViewModel()
        return RootViewController(viewModel: rootViewModel)
    }
    
    private func createRootViewModel() -> RootViewModel {
        return RootViewModel()
    }
    
    // Splash Factory
    
    private func createSplashViewController() -> SplashViewController {
        let viewModel = createSplashViewModel()
        return SplashViewController(viewModel: viewModel)
    }
    
    private func createSplashViewModel() -> SplashViewModel {
        let accessTokenRepository = createAccessTokenRepository()
        return SplashViewModel(accessTokenRepository: accessTokenRepository)
    }
    
    private func createAccessTokenRepository() -> AccessTokenRepository {
        // return YourNameAccessTokenRepository()
        #warning("⚠️ TODO: Fake 객체를 추후에 제거해야합니다.") // Booung
        return FakeAccessTokenRepository()
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
    private func createSignedInDependencyContainer() -> SignedInDependencyContainer {
        return SignedInDependencyContainer(rootDependencyContainer: self)
    }
    
    // SignedOutDependencyContainer Factory
    private func createSignedOutDependencyContainer() -> SignedOutDependencyContainer {
        return SignedOutDependencyContainer(rootDependencyContainer: self)
    }
    
}
