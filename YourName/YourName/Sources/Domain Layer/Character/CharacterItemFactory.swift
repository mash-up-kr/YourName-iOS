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

final class CharacterItemFactoryImpl {
    
    func create(by category: ItemCategory) -> [CharacterItem] {
        return [Int](1...category.numberOfItems).map { index in
            CharacterItem(
                type: category,
                itemID: "\(category.key)_\(index)",
                displayItemID: "\(category.key)_\(index)_for_display"
            )
        }
    }
    
}
