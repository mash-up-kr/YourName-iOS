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
    func createMyCard(_ nameCard: Entity.NameCard) -> Observable<Void>
    func fetchMyCards() -> Observable<[Entity.NameCard]>
    func removeMyCard(id: CardID) -> Observable<Entity.Empty>
}

final class YourNameMyCardRepository: MyCardRepository {
    
    func createMyCard(_ nameCard: Entity.NameCard) -> Observable<Void> {
        return .empty()
    }
    
    func fetchMyCards() -> Observable<[Entity.NameCard]> {
        return Environment.current.network.request(MyNameCardsAPI())
            .compactMap { $0.list }
    }
    
    func removeMyCard(id: CardID) -> Observable<Entity.Empty> {
        return Environment.current.network.request(RemoveMyNameCardAPI(id: id))
    }
}
