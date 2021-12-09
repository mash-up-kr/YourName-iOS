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
    func updateMyCard(id: Identifier, nameCard: Entity.NameCardCreation) -> Observable<Void>
    func removeMyCard(id: Identifier) -> Observable<Entity.Empty>
}

final class YourNameMyCardRepository: MyCardRepository {
    
    init(network: NetworkServing = Environment.current.network) {
        self.network = network
    }
    
    func createMyCard(_ nameCard: Entity.NameCardCreation) -> Observable<Void> {
        return network.request(NewCardAPI(nameCard: nameCard)).mapToVoid()
    }
    
    func fetchMyCards() -> Observable<[Entity.NameCard]> {
        return network.request(MyNameCardsAPI()).compactMap { $0.list }
    }
    
    func updateMyCard(id: Identifier, nameCard: Entity.NameCardCreation) -> Observable<Void> {
        return network.request(UpdateCardAPI(cardID: id, nameCard: nameCard)).mapToVoid()
    }
    
    func removeMyCard(id: Identifier) -> Observable<Entity.Empty> {
        return network.request(RemoveMyNameCardAPI(id: id))
    }
    
    private let network: NetworkServing
}
