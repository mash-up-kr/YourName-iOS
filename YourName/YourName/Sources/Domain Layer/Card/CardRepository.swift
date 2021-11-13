//
//  CardRepository.swift
//  MEETU
//
//  Created by Booung on 2021/11/13.
//

import Foundation
import RxSwift

protocol CardRepository {
    func fetchCards(cardBookID: String) -> Observable<[Card]>
}

final class CardRepositoryImpl: CardRepository {
    func fetchCards(cardBookID: String) -> Observable<[Card]> {
        .empty()
    }
}

final class MockCardRepository: CardRepository {
    func fetchCards(cardBookID: String) -> Observable<[Card]> {
        .just(Card.dummyList)
    }
}
