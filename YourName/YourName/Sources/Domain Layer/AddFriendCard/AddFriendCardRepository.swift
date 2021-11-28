//
//  AddFriendCardRepository.swift
//  MEETU
//
//  Created by seori on 2021/11/27.
//

import Foundation
import RxSwift

protocol AddFriendCardRepository {
    func searchFriendCard(uniqueCode: String) -> Observable<Entity.SearchFriendCard>
    func addFriendCard(uniqueCode: String) -> Observable<Entity.Empty>
}

final class YourNameAddFriendCardRepository: AddFriendCardRepository {
    func searchFriendCard(uniqueCode: String) -> Observable<Entity.SearchFriendCard> {
        return Environment.current.network.request(SearchFriendCardAPI(uniqueCode: uniqueCode))
    }
    
    func addFriendCard(uniqueCode: String) -> Observable<Entity.Empty> {
        return Environment.current.network.request(<#T##api: ServiceAPI##ServiceAPI#>)
    }
}
