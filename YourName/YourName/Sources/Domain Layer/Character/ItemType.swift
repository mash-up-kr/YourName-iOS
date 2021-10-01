//
//  ItemType.swift
//  YourName
//
//  Created by Booung on 2021/10/02.
//

import Foundation

enum ItemType: Int, CaseIterable, Equatable {
    case body
    case eye
    case nose
    case mouth
    case hairAccessory
    case accessory
}
extension ItemType: CustomStringConvertible {
    var description: String {
        switch self {
        case .body: return "몸"
        case .eye: return "눈"
        case .nose: return "코"
        case .mouth: return "입"
        case .hairAccessory: return "장식1"
        case .accessory: return "장식2"
        }
    }
}
