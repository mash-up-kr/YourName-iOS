//
//  AddFriendCardRepository.swift
//  MEETU
//
//  Created by seori on 2021/11/27.
//

import Foundation
import RxSwift

protocol AddFriendCardRepository {
    func addFriendCard(uniqueCode: String) -> Observable<Entity.Empty>
}

final class YourNameAddFriendCardRepository: AddFriendCardRepository {
    
    func addFriendCard(uniqueCode: String) -> Observable<Entity.Empty> {
        return Environment.current.network.request(AddFriendCardAPI(uniqueCode: uniqueCode))
    }
}
