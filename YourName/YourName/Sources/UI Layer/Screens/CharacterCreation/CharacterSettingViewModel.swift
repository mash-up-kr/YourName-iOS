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
    let selectedCategory = BehaviorRelay<ItemCategory>(value: .body)
    let items = BehaviorRelay<[ItemCategory: [CharacterItem]]>(value: [:])
    
    init(characterItemRepository: CharacterItemRepository) {
        self.characterItemRepository = characterItemRepository
    }
    
    func didLoad() {
        ItemCategory.allCases.forEach { category in
            characterItemRepository.fetchItems(type: category)
                .subscribe(onNext: { [weak self] loadedItems in
                    var loadedItems = loadedItems
                    var newItems = self?.items.value
                    if let emptyItem = CharacterItem.empty(typeOf: category) {
                        loadedItems.insert(emptyItem, at: 0)
                    }
                    newItems?[category] = loadedItems
                    self?.items.accept(newItems ?? [:])
                })
                .disposed(by: disposeBag)
        }
    }
    
    func tapCategory(at index: Int) {
        guard let category = ItemCategory(rawValue: index) else { return }
        selectedCategory.accept(category)
    }
    
    func tapItem(at index: Int) {
    }
    
    private let disposeBag = DisposeBag()
    private let characterItemRepository: CharacterItemRepository
    
}
