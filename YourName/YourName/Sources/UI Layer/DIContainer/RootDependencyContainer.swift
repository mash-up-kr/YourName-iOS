//
//  AppContainer.swift
//  YourName
//
//  Created by Booung on 2021/09/18.
//

import Foundation

final class RootDependencyContainer {
    
    func createRootViewController() -> RootViewController {
        let rootViewModel = createRootViewModel()
        return RootViewController(viewModel: rootViewModel)
    }
    
    private func createRootViewModel() -> RootViewModel {
        return RootViewModel()
    }
    
    private func createSignedInDependencyContainer() -> SignedInDependencyContainer {
        return SignedInDependencyContainer(rootDependencyContainer: self)
    }
}
