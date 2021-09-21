//
//  MyCardListDependencyContainer.swift
//  YourName
//
//  Created by Booung on 2021/09/21.
//

import Foundation

final class MyCardListDependencyContainer {
    
    init(signedInDependencyContainer: SignedInDependencyContainer) {
        
    }
    
    func createMyCardListViewController() -> MyCardListViewController {
        let viewModel = createMyCardListViewModel()
        return MyCardListViewController(viewModel: viewModel)
    }
    
    private func createMyCardListViewModel() -> MyCardListViewModel {
        return MyCardListViewModel()
    }
}
