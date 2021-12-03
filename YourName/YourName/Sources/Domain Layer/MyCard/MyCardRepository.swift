//
//  MyCardRepository.swift
//  MEETU
//
//  Created by seori on 2021/11/26.
//

import Foundation
import RxSwift
import UIKit

protocol MyCardRepository {
    func createMyCard(_ nameCard: Entity.NameCardCreation) -> Observable<Void>
    func fetchMyCards() -> Observable<[Entity.NameCard]>
    func removeMyCard(id: Identifier) -> Observable<Entity.Empty>
}

final class YourNameMyCardRepository: MyCardRepository {
    
    init(network: NetworkServing = Environment.current.network) {
        self.network = network
    }
    
    func createMyCard(_ nameCard: Entity.NameCardCreation) -> Observable<Void> {
        return network.request(MakeCardAPI(nameCard: nameCard)).map { _ in Void() }
    }
    
    func fetchMyCards() -> Observable<[Entity.NameCard]> {
        return Environment.current.network.request(MyNameCardsAPI())
            .compactMap { $0.list }
    }
    
    private let network: NetworkServing
    
    func removeMyCard(id: Identifier) -> Observable<Entity.Empty> {
        return Environment.current.network.request(RemoveMyNameCardAPI(id: id))
    }
}
