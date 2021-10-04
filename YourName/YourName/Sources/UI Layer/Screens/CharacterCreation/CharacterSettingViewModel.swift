//
//  CharacterCreationViewModel.swift
//  YourName
//
//  Created by Booung on 2021/10/02.
//

import Foundation

final class CharacterSettingViewModel {
    
    init(characterItemRepository: CharacterItemRepository) {
        self.characterItemRepository = characterItemRepository
    }
    
    private let characterItemRepository: CharacterItemRepository
}
