//
//  Entity.SearchFriendCard.swift
//  MEETU
//
//  Created by seori on 2021/11/27.
//

import Foundation

extension Entity {
    struct SearchFriendCard: Decodable {
        typealias NameCard = Entity.NameCard
        
        let nameCard: NameCard?
        let isAdded: Bool?
    }
}
