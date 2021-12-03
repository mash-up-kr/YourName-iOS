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
}

final class MockCardBookRepository: CardBookRepository {
    
    func fetchAll() -> Observable<[CardBook]> {
        return .just(CardBook.dummy)
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
