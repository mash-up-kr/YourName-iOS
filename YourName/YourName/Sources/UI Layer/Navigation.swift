//
//  NavigationAction.swift
//  YourName
//
//  Created by Booung on 2021/09/18.
//

import Foundation


enum NavigationAction: Equatable {
    case present
    case push
}

struct Navigation<Destination: Equatable>: Equatable {
    let action: NavigationAction
    let destination: Destination
}

extension Navigation {
    static func present(_ destination: Destination) -> Self {
        return Navigation(action: .present, destination: destination)
    }
    
    static func push(_ destination: Destination) -> Self {
        return Navigation(action: .push, destination: destination)
    }
}
