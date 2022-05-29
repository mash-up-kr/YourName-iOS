//
//  NavigationAction.swift
//  YourName
//
//  Created by Booung on 2021/09/18.
//

import Foundation

public enum NavigationAction: Equatable {
    case present(animated: Bool = true)
    case push
    case show(withDimmed: Bool = false)
}

public struct Navigation<Destination: Equatable>: Equatable {
    let action: NavigationAction
    let destination: Destination
}

extension Navigation {
    
    public static func present(_ destination: Destination, animated: Bool = true) -> Self {
        return Navigation(action: .present(animated: animated), destination: destination)
    }
    
    public static func push(_ destination: Destination) -> Self {
        return Navigation(action: .push, destination: destination)
    }
    
    public static func show(_ destination: Destination, withDimmed dimmed: Bool = true) -> Self {
        return Navigation(action: .show(withDimmed: dimmed), destination: destination)
    }
}
