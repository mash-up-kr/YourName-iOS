//
//  CharacterItem.swift
//  YourName
//
//  Created by Booung on 2021/10/02.
//

import Foundation

struct CharacterItem {
    let type: ItemCategory
    let itemID: String
    let displayItemID: String
}
extension CharacterItem {
    static func empty(typeOf type: ItemCategory) -> CharacterItem? {
        guard type.isOption else { return nil }
        return CharacterItem(type: type, itemID: .empty, displayItemID: "no_item_for_display")
    }
}
