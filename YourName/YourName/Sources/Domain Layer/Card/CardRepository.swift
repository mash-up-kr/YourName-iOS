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
    func remove(cardIDs: [NameCardID], on cardBookID: CardBookID) -> Observable<Void>
    func fetchCard(uniqueCode: UniqueCode) -> Observable<Entity.FriendCard>
    func migrateCards(at cardBookID: CardBookID, cards: [NameCardID]) -> Observable<Void>
}

final class YourNameCardRepository: CardRepository {
    
    init(network: NetworkServing = Environment.current.network) {
        self.network = network
    }
    
    func fetchAll() -> Observable<[NameCard]> {
        return network.request(AllFriendCardAPI())
            .compactMap { response in response.list?.compactMap { $0.nameCard } }
            .compactMap { [weak self] list in return list.compactMap { self?.translate(fromEntity: $0) } }
    }
    
    func fetchCards(cardBookID: CardBookID) -> Observable<[NameCard]> {
        return network.request(FriendCardsAPI(cardBookID: cardBookID))
            .compactMap { response in response.list?.compactMap { $0.nameCard } }
            .compactMap { [weak self] list in return list.compactMap { self?.translate(fromEntity: $0) } }
    }
    
    func fetchCard(uniqueCode: UniqueCode) -> Observable<Entity.FriendCard> {
        return Environment.current.network.request(FriendCardAPI(uniqueCode: uniqueCode))
    }
    
    func remove(cardIDs: [NameCardID], on cardBookID: CardBookID) -> Observable<Void> {
        return network.request(DeleteCardsAPI(cardBookID: cardBookID, cardIDs: cardIDs)).mapToVoid()
    }
    
    func migrateCards(at cardBookID: CardBookID, cards: [NameCardID]) -> Observable<Void> {
        return network.request(MigrateCardsAPI(cardBookId: cardBookID, cardIds: cards)).mapToVoid()
    }
    
    private func translate(fromEntity entity: Entity.NameCard) -> NameCard {
        return NameCard(id: entity.id, uniqueCode: entity.uniqueCode, name: entity.name, role: entity.role, introduce: entity.introduce, bgColors: entity.bgColor?.value, profileURL: entity.imgUrl, idForDelete: entity.id)
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
    
    func remove(cardIDs: [NameCardID], on cardBookID: CardBookID) -> Observable<Void> {
        .just(Void())
    }
    func fetchCard(uniqueCode: UniqueCode) -> Observable<Entity.FriendCard> {
        return Environment.current.network.request(FriendCardAPI(uniqueCode: uniqueCode))
    }
    
    func migrateCards(at cardBookID: CardBookID, cards: [NameCardID]) -> Observable<Void> {
        return .empty()
    }
}
