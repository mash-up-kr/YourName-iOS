//
//  NavigationAction.swift
//  YourName
//
//  Created by Booung on 2021/09/18.
//

import Foundation

enum NavigationAction: Equatable {
    case present(animated: Bool = true)
    case push
    case show(withDimmed: Bool = false)
}

struct Navigation<Destination: Equatable>: Equatable {
    let action: NavigationAction
    let destination: Destination
}

extension Navigation {
    static func present(_ destination: Destination) -> Self {
        return Navigation(action: .present(animated: true), destination: destination)
    }
    
    static func push(_ destination: Destination) -> Self {
        return Navigation(action: .push, destination: destination)
    }
    
    static func show(_ destination: Destination, withDimmed dimmed: Bool = false) -> Self {
        return Navigation(action: .show(withDimmed: dimmed), destination: destination)
    }
}
