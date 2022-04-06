//
//  CardBookAPI.swift
//  MEETU
//
//  Created by Seori on 2022/04/06.
//

import Foundation

struct CardBookAPI: ServiceAPI {
    private let cardBookID: CardBookID
    var path: String { "/collections/\(cardBookID)" }
    var method: Method { .get }
    var task: NetworkingTask { .requestPlain }
    typealias Response = Entity.CardBook
    
    init(cardBookID: CardBookID) {
        self.cardBookID = cardBookID
    }
}
