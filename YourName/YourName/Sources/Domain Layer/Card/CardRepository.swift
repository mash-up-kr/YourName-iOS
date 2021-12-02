//
//  CardRepository.swift
//  MEETU
//
//  Created by Booung on 2021/11/13.
//

import Foundation
import RxSwift

protocol CardRepository {
    func fetchAll() -> Observable<[NameCard]>
    func fetchCards(cardBookID: CardBookID) -> Observable<[NameCard]>
    func remove(cardIDs: [NameCardID]) -> Observable<[NameCardID]>
}

final class YourNameCardRepository: CardRepository {
    
    init(network: NetworkServing = Environment.current.network) {
        self.network = network
    }
    
    func fetchAll() -> Observable<[NameCard]> {
        .empty()
    }
    
    func fetchCards(cardBookID: CardBookID) -> Observable<[NameCard]> {
        .empty()
    }
    
    func remove(cardIDs: [NameCardID]) -> Observable<[NameCardID]> {
        .empty()
    }
    
    private let network: NetworkServing
    
}

final class MockCardRepository: CardRepository {
    
    func fetchAll() -> Observable<[NameCard]> {
        .just(NameCard.dummyList)
    }
    
    func fetchCards(cardBookID: CardBookID) -> Observable<[NameCard]> {
        .just(NameCard.dummyList)
    }
    
    func remove(cardIDs: [NameCardID]) -> Observable<[NameCardID]> {
        return .just(cardIDs)
    }
}
