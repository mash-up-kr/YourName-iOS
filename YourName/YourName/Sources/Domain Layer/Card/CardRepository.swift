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
        return network.request(AllFriendCardAPI())
            .compactMap { $0.list }
            .compactMap { [weak self] list in return list.compactMap { self?.translate(fromEntity: $0) } }
    }
    
    func fetchCards(cardBookID: CardBookID) -> Observable<[NameCard]> {
        return network.request(FriendCardsAPI(cardBookID: cardBookID))
            .compactMap { $0.list }
            .compactMap { [weak self] list in return list.compactMap { self?.translate(fromEntity: $0) } }
    }
    
    func remove(cardIDs: [NameCardID]) -> Observable<[NameCardID]> {
        .empty()
    }
    
    private func translate(fromEntity entity: Entity.NameCard) -> NameCard {
        return NameCard(id: entity.id, name: entity.name, role: entity.role, introduce: entity.introduce, bgColors: entity.bgColor?.value, profileURL: entity.imgUrl)
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
