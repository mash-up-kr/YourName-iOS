//
//  SignedOutDependencyContainer.swift
//  YourName
//
//  Created by Booung on 2021/09/18.
//

import Foundation

final class SignedOutDependencyContainer {
    
    init(rootDependencyContainer: RootDependencyContainer) {
        // do something
        // get state of rootDependencyContainer
    }
    
    func createSignInViewController() -> SignInViewController {
        let signInViewModel = createSignInViewModel()
        let viewController = SignInViewController.instantiate()
        viewController.viewModel = signInViewModel
        return viewController
    }
    
    private func createSignInViewModel() -> SignInViewModel {
        return SignInViewModel()
    }
}
