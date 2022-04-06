//
//  CardBookRepository.swift
//  YourName
//
//  Created by seori on 2021/10/03.
//

import Foundation
import RxSwift

protocol CardBookRepository {
    func fetchAll() -> Observable<[CardBook]>
    func addCardBook(name: String, desc: String, bgColorId: Int) -> Observable<Void>
    func fetchCardBook(id: CardBookID) -> Observable<Entity.CardBook>
    func editCardBook(cardBookID: CardBookID, name: String, desc: String, bgColorId: Int) -> Observable<Void>
    func deleteCardBook(id: CardBookID) -> Observable<Entity.Empty>
}

final class MockCardBookRepository: CardBookRepository {
    
    func addCardBook(name: String, desc: String, bgColorId: Int) -> Observable<Void> {
        return .empty()
    }
    
    func fetchAll() -> Observable<[CardBook]> {
        return .just(CardBook.dummy)
    }
    func fetchCardBook(id: CardBookID) -> Observable<Entity.CardBook> {
        return .empty()
    }
    func editCardBook(cardBookID: CardBookID, name: String, desc: String, bgColorId: Int) -> Observable<Void> {
        return .empty()
    }
    func deleteCardBook(id: CardBookID) -> Observable<Entity.Empty> {
        return .empty()
    }
}


final class YourNameCardBookRepository: CardBookRepository {
    
    init(network: NetworkServing = Environment.current.network) {
        self.network = network
    }
    
    func fetchAll() -> Observable<[CardBook]> {
        return network.request(CardBooksAPI())
            .compactMap { [weak self] response in
                guard let self = self else { return nil }
                return (response.list ?? []).compactMap(self.translate(fromEntity:))
            }
    }
    
    func addCardBook(name: String, desc: String, bgColorId: Int) -> Observable<Void> {
        return network.request(AddCardBookAPI(name: name, desc: desc, bgColorId: bgColorId))
            .mapToVoid()
    }
    
    func fetchCardBook(id: CardBookID) -> Observable<Entity.CardBook> {
        return network.request(CardBookAPI(cardBookID: id))
    }
    
    func editCardBook(cardBookID: CardBookID, name: String, desc: String, bgColorId: Int) -> Observable<Void> {
        return network.request(EditCardBookAPI(
            cardBookID: cardBookID,
            name: name,
            desc: desc,
            bgColorID: bgColorId
        ))
        .mapToVoid()
    }
    
    func deleteCardBook(id: CardBookID) -> Observable<Entity.Empty> {
        return network.request(<#T##api: ServiceAPI##ServiceAPI#>)
    }
    private func translate(fromEntity entity: Entity.CardBook) -> CardBook {
        return CardBook(
            id: entity.id,
            title: entity.name,
            count: entity.numberOfNameCards,
            description: entity.description,
            backgroundColor: entity.bgColor?.value
        )
    }
    
    private let network: NetworkServing
}
