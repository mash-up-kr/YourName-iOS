//
//  UpdateCardAPI.swift
//  MEETU
//
//  Created by Booung on 2021/12/10.
//

import Foundation

struct UpdateCardAPI: ServiceAPI {
    let cardID: Identifier
    let nameCard: Entity.NameCardCreation
    
    var path: String { "/namecards/\(cardID)" }
    var method: Method { .put }
    var task: NetworkingTask {
        return .requestJSONEncodable(nameCard)
    }
}
extension UpdateCardAPI {
    typealias Response = Entity.Empty
}
