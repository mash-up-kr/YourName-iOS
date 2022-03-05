//
//  AddFriendCardRepository.swift
//  MEETU
//
//  Created by seori on 2021/11/27.
//

import Foundation
import RxSwift

protocol AddFriendCardRepository {
    func addFriendCard(at cardBooks: [Identifier], uniqueCode: UniqueCode) -> Observable<Entity.Empty>
}

final class YourNameAddFriendCardRepository: AddFriendCardRepository {
    
    func addFriendCard(at cardBooks: [Identifier] = ["1"], uniqueCode: UniqueCode) -> Observable<Entity.Empty> {
        return Environment.current.network.request(AddFriendCardAPI(uniqueCode: uniqueCode, collectionIds: cardBooks))
    }
}
