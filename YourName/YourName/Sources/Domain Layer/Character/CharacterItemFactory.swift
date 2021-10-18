//
//  CharacterItemFactory.swift
//  YourName
//
//  Created by Booung on 2021/10/05.
//

import Foundation

protocol CharacterItemFactory {
    func create(by category: ItemCategory) -> [CharacterItem]
}

final class CharacterItemFactoryImpl: CharacterItemFactory {
    
    func create(by category: ItemCategory) -> [CharacterItem] {
        var items = [Int](1...category.numberOfItems).map { index in
            CharacterItem(
                type: category,
                itemID: "\(category.key)_\(index)",
                displayItemID: "\(category.key)_\(index)_for_display"
            )
        }
        if category.isOption, let emptyItem = CharacterItem.empty(typeOf: category) {
            items.insert(emptyItem, at: 0)
        }
        return items
    }
    
}
