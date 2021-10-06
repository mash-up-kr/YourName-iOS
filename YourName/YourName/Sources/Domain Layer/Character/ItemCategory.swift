//
//  ItemCategory.swift
//  YourName
//
//  Created by Booung on 2021/10/05.
//

import Foundation

enum ItemCategory: Int, CaseIterable, Equatable, Hashable {
    case body
    case eye
    case nose
    case mouth
    case hairAccessory
    case accessory
}
extension ItemCategory: CustomStringConvertible {
    
    var key: String {
        switch self {
        case .body:             return "body"
        case .eye:              return "eye"
        case .nose:             return "nose"
        case .mouth:            return "mouth"
        case .hairAccessory:    return "item1"
        case .accessory:        return "item2"
        }
    }
    
    var isOption: Bool {
        switch self {
        case .body, .eye, .nose, .mouth: return false
        case .hairAccessory, .accessory: return true
        }
    }
    
    var numberOfItems: Int {
        switch self {
        case .body:             return 6
        case .eye:              return 12
        case .nose:             return 6
        case .mouth:            return 12
        case .hairAccessory:    return 11
        case .accessory:        return 8
        }
    }
    
    var description: String {
        switch self {
        case .body:             return "몸"
        case .eye:              return "눈"
        case .nose:             return "코"
        case .mouth:            return "입"
        case .hairAccessory:    return "장식1"
        case .accessory:        return "장식2"
        }
    }
}
