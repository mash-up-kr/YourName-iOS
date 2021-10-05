//
//  CharacterCreationViewModel.swift
//  YourName
//
//  Created by Booung on 2021/10/02.
//

import Foundation
import RxRelay

final class CharacterSettingViewModel {
    
    let characterMeta = BehaviorRelay<CharacterMeta>(value: .default)
    let selectedCategory = BehaviorRelay<ItemCategory>(value: .body)
    
    init(characterItemRepository: CharacterItemRepository) {
        self.characterItemRepository = characterItemRepository
    }
    
    func tapCategory(at index: Int) {
        guard let category = ItemCategory(rawValue: index) else { return }
        selectedCategory.accept(category)
    }
    
    func tapItem(at index: Int) {
    }
    
    private let characterItemRepository: CharacterItemRepository
    
}
