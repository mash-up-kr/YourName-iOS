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
    let categories = BehaviorRelay<[ItemCategory]>(value: ItemCategory.allCases)
    
    init(characterItemRepository: CharacterItemRepository) {
        self.characterItemRepository = characterItemRepository
    }
    
    private let characterItemRepository: CharacterItemRepository
    
}
