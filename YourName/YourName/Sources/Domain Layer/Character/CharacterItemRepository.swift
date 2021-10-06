//
//  CharacterItemRepository.swift
//  YourName
//
//  Created by Booung on 2021/10/02.
//

import Foundation
import RxSwift

protocol CharacterItemRepository {
    func fetchItems(type: ItemCategory) -> Observable<[CharacterItem]>
}

final class CharacterItemRepositoryImpl: CharacterItemRepository {
    
    init(factory: CharacterItemFactory) {
        self.factory = factory
    }
    
    func fetchItems(type: ItemCategory) -> Observable<[CharacterItem]> {
        return .just(factory.create(by: type))
    }
    
    private let factory: CharacterItemFactory
}
