//
//  CategoryItemsViewModel.swift
//  YourName
//
//  Created by Booung on 2021/10/06.
//

import Foundation
import RxSwift
import RxRelay

protocol DisplayCharacterItemsResponder: AnyObject {
    func selectDisplayCategoryItem(_ item: CharacterItem)
}

final class DisplayCharacterItemsViewModel {
    
    let items = BehaviorRelay<[CharacterItem]>(value: [])
    let selectedIndex = BehaviorRelay<Int>(value: 0)
    
    init(
        category: ItemCategory,
        characterItemRepository: CharacterItemRepository,
        displayCharacterItemsResponder: DisplayCharacterItemsResponder
    ) {
        self.category = category
        self.characterItemRepository = characterItemRepository
        self.displayCharacterItemsResponder = displayCharacterItemsResponder
    }
    
    func didLoad() {
        characterItemRepository.fetchItems(type: category)
            .bind(to: items)
            .disposed(by: disposeBag)
    }
    
    func tapItem(at index: Int) {
        guard let selectedItem = self.items.value[safe: index] else { return }
        displayCharacterItemsResponder.selectDisplayCategoryItem(selectedItem)
    }
    
    private let disposeBag = DisposeBag()
    
    private let category: ItemCategory
    private let characterItemRepository: CharacterItemRepository
    private let displayCharacterItemsResponder: DisplayCharacterItemsResponder
}
