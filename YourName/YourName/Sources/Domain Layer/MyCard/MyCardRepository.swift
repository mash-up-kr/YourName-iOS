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
    func fetchMyFrontCard() -> Observable<[CardFrontView.Item]>
}

final class YourNameMyCardRepository: MyCardRepository {
    
    typealias FrontCardItem = CardFrontView.Item
    func fetchMyCards() -> Observable<[Entity.MyNameCard.NameCard]> {
        return Environment.current.network.request(MyNameCardsAPI())
            .compactMap { $0.list }
    }
    
    func fetchMyFrontCard() -> Observable<[FrontCardItem]> {
        return Environment.current.network.request(MyNameCardsAPI())
            .compactMap { $0.list }
            .compactMap { cards -> [FrontCardItem]? in
                return cards.compactMap { card -> FrontCardItem? in
                    
                    guard let personalSkills = card.personalSkills,
                          let bgColors = card.bgColor?.value else { return nil }
                    let skills = personalSkills.map { MySkillProgressView.Item(title: $0.name, level: $0.level?.rawValue ?? 0) }
                    
                    let bgColor: ColorSource!
                    
                    if bgColors.count == 1 {
                        bgColor = .monotone(UIColor(hexString: bgColors.first!))
                    } else {
                        bgColor = .gradient(bgColors.map { UIColor(hexString: $0) })
                    }
                    return FrontCardItem(id: card.id ?? 0,
                                         image: card.image?.key ?? "",
                                         name: card.name ?? "",
                                         role: card.role ?? "",
                                         skills: skills,
                                         backgroundColor: bgColor)
                }
            }
    }
}
