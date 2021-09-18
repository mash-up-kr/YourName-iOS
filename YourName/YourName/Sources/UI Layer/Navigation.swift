//
//  NavigationAction.swift
//  YourName
//
//  Created by Booung on 2021/09/18.
//

import Foundation

enum Navigation<Path> {
    case present(Path)
    case push(Path)
}
