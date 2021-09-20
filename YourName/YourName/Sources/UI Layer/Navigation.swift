//
//  NavigationAction.swift
//  YourName
//
//  Created by Booung on 2021/09/18.
//

import Foundation

enum Navigation<Path: Equatable>: Equatable {
    case present(Path)
    case push(Path)
}
