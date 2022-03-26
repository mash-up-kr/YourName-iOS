//
//  MigrateCardsAPI.swift
//  MEETU
//
//  Created by Seori on 2022/03/27.
//

import Foundation
import Moya

struct MigrateCardsAPI: ServiceAPI {
    typealias Response = Entity.Empty
    
    var path: String { "/collections/\(cardBookId)/namecards"}
    var method: Method { .post }
    var headers: [String : String]? { Environment.current.network.headers }
    var task: Moya.Task {
        .requestParameters(parameters: ["namecardIds": cardIds],
                           encoding: JSONEncoding.default)
    }
    
    private let cardBookId: CardBookID
    private let cardIds: [NameCardID]
    
    init(
        cardBookId: CardBookID,
        cardIds: [NameCardID]
    ) {
        self.cardBookId = cardBookId
        self.cardIds = cardIds
    }
}
