//
//  UpdateCardAPI.swift
//  MEETU
//
//  Created by Booung on 2021/12/10.
//

import Foundation

struct UpdateCardAPI: ServiceAPI {
    private let uniqueCode: UniqueCode
    private let nameCard: Entity.NameCardCreation
    
    init(uniqueCode: UniqueCode, nameCard: Entity.NameCardCreation) {
        self.uniqueCode = uniqueCode
        self.nameCard = nameCard
    }
    
    var path: String { "/namecards/\(uniqueCode)" }
    var method: Method { .put }
    var task: NetworkingTask {
        return .requestJSONEncodable(nameCard)
    }
}
extension UpdateCardAPI {
    typealias Response = Entity.Empty
}
