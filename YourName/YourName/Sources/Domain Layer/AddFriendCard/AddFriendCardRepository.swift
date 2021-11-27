//
//  AddFriendCardRepository.swift
//  MEETU
//
//  Created by seori on 2021/11/27.
//

import Foundation
import RxSwift

protocol AddFriendCardRepository {
    func searchFriendCard(uniqueCode: String) -> Observable<Entity.AddFriendCard>
}

final class YourNameAddFriendCardRepository: AddFriendCardRepository {
    func searchFriendCard(uniqueCode: String) -> Observable<Entity.AddFriendCard> {
        return Environment.current.network.request(AddFriendCardAPI(uniqueCode: uniqueCode))
    }
}
