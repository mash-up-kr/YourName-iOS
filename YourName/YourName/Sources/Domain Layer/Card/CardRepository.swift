//
//  CardRepository.swift
//  MEETU
//
//  Created by Booung on 2021/11/13.
//

import Foundation
import RxSwift

typealias CardID = String

protocol CardRepository {
    func fetchCards(cardBookID: String) -> Observable<[NameCard]>
    func remove(cardIDs: [CardID]) -> Observable<[CardID]>
    func fetchCard(uniqueCode: String) -> Observable<Entity.FriendCard>
}

final class YourNameCardRepository: CardRepository {
    
    func fetchCards(cardBookID: String) -> Observable<[NameCard]> {
        .empty()
    }
    
    func remove(cardIDs: [CardID]) -> Observable<[CardID]> {
        .empty()
    }
    
    func fetchCard(uniqueCode: String) -> Observable<Entity.FriendCard> {
        return Environment.current.network.request(FriendCardAPI(uniqueCode: uniqueCode))
    }
    
}

final class MockCardRepository: CardRepository {
    
    func fetchCards(cardBookID: String) -> Observable<[NameCard]> {
        .just(NameCard.dummyList)
    }
    
    func remove(cardIDs: [CardID]) -> Observable<[CardID]> {
        return .just(cardIDs)
    }
    func fetchCard(uniqueCode: String) -> Observable<Entity.FriendCard> {
        return Environment.current.network.request(FriendCardAPI(uniqueCode: uniqueCode))
    }
    
}
