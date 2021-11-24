//
//  Set+.swift
//  MEETU
//
//  Created by Booung on 2021/11/25.
//

import Foundation

extension Set {
    mutating func toggle(_ member: Element) {
        if self.contains(member) {
            self.remove(member)
        } else {
            self.insert(member)
        }
    }
}
