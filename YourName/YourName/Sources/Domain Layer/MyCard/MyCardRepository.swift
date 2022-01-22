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
    func updateMyCard(uniqueCode: UniqueCode, nameCard: Entity.NameCardCreation) -> Observable<Void>
    func removeMyCard(uniqueCode: UniqueCode) -> Observable<Entity.Empty>
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
    
    func updateMyCard(uniqueCode: UniqueCode, nameCard: Entity.NameCardCreation) -> Observable<Void> {
        return network.request(UpdateCardAPI(uniqueCode: uniqueCode, nameCard: nameCard)).mapToVoid()
    }
    
    func removeMyCard(uniqueCode: UniqueCode) -> Observable<Entity.Empty> {
        return network.request(RemoveMyNameCardAPI(uniqueCode: uniqueCode))
    }
    
    private let network: NetworkServing
}
