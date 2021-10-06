//
//  CharacterCreationViewModel.swift
//  YourName
//
//  Created by Booung on 2021/10/02.
//

import Foundation
import RxSwift
import RxRelay

final class CharacterSettingViewModel {
    
    let characterMeta = BehaviorRelay<CharacterMeta>(value: .default)
    let categories = BehaviorRelay<[ItemCategory]>(value: ItemCategory.allCases)
    let selectedCategory = BehaviorRelay<ItemCategory?>(value: nil)
    
    init(characterItemRepository: CharacterItemRepository) {
        self.characterItemRepository = characterItemRepository
    }
    
    func didLoad() {
        selectedCategory.accept(.body)
    }
    
    func tapCategory(at index: Int) {
        guard let category = self.categories.value[safe: index] else { return }
        selectedCategory.accept(category)
    }
    
    private let disposeBag = DisposeBag()
    private let characterItemRepository: CharacterItemRepository
    
}
extension CharacterSettingViewModel: DisplayCharacterItemsResponder {
    
    func selectDisplayCategoryItem(_ item: CharacterItem) {
        var newCharaterMeta = characterMeta.value
        switch item.type {
        case .body:          newCharaterMeta.bodyID = item.itemID
        case .eye:           newCharaterMeta.eyeID = item.itemID
        case .nose:          newCharaterMeta.noseID = item.itemID
        case .mouth:         newCharaterMeta.mouthID = item.itemID
        case .hairAccessory: newCharaterMeta.hairAccessoryID = item.itemID
        case .accessory:     newCharaterMeta.etcAccesstoryID = item.itemID
        }
        characterMeta.accept(newCharaterMeta)
    }
}
