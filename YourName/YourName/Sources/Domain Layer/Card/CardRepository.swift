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
}

final class CardRepositoryImpl: CardRepository {
    
    func fetchCards(cardBookID: String) -> Observable<[NameCard]> {
        .empty()
    }
    
    func remove(cardIDs: [CardID]) -> Observable<[CardID]> {
        .empty()
    }
    
}

final class MockCardRepository: CardRepository {
    
    func fetchCards(cardBookID: String) -> Observable<[NameCard]> {
        .just(NameCard.dummyList)
    }
    
    func remove(cardIDs: [CardID]) -> Observable<[CardID]> {
        return .just(cardIDs)
    }
}
