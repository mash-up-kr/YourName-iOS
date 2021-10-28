//
//  Array+.swift
//  YourName
//
//  Created by Booung on 2021/09/21.
//

import Foundation

extension Array {
    subscript(safe index: Int) -> Element? {
        get {
            guard indices ~= index else { return nil }
            return self[index]
        }
    }
}
