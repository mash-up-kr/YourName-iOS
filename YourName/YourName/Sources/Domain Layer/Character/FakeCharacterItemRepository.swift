//
//  FakeCharacterItemRepository.swift
//  YourName
//
//  Created by Booung on 2021/10/02.
//

import Foundation
import RxSwift

final class FakeCharacterItemRepository: CharacterItemRepository {
    
    func fetchItems(type: ItemCategory) -> Observable<[CharacterItem]> {
        return .just([])
    }
    
}
