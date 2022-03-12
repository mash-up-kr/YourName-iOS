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
    
    func deleteCardBook(cardBookID: CardBookID) -> Observable<Void>
}

final class MockCardBookRepository: CardBookRepository {
    func deleteCardBook(cardBookID: CardBookID) -> Observable<Void> {
        return .empty()
    }
    
    
    func addCardBook(name: String, desc: String, bgColorId: Int) -> Observable<Void> {
        return .empty()
    }
    
    func fetchAll() -> Observable<[CardBook]> {
        return .just(CardBook.dummy)
    }
}


final class YourNameCardBookRepository: CardBookRepository {
    
    init(network: NetworkServing = Environment.current.network) {
        self.network = network
    }
    
    func deleteCardBook(cardBookID: CardBookID) -> Observable<Void> {
        return network.request(DeleteCardBookAPI(cardBookID: cardBookID))
            .mapToVoid()
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
