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
    func fetchMyCards() -> Observable<[Entity.MyNameCard.NameCard]>
}

final class YourNameMyCardRepository: MyCardRepository {
    
    func fetchMyCards() -> Observable<[Entity.MyNameCard.NameCard]> {
        return Environment.current.network.request(MyNameCardsAPI())
            .compactMap { $0.list }
    }
}
