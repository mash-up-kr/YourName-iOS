//
//  RootContainer.swift
//  YourName
//
//  Created by Booung on 2021/09/17.
//

import Foundation

struct RootContainer {
    
    func rootViewController() -> RootViewController {
        return RootViewController(viewModel: rootViewModel())
    }
    
    private func rootViewModel() -> RootViewModel {
        return RootViewModel()
    }
}
