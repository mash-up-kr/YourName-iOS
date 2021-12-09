//
//  RemoveMyNameCardAPI.swift
//  MEETU
//
//  Created by seori on 2021/11/30.
//

import Foundation

struct RemoveMyNameCardAPI: ServiceAPI {
    typealias Response = Entity.Empty
    private let id: Identifier
    var path: String { "/namecards/\(id)" }
    var method: Method { .delete }
    var task: NetworkingTask { .requestPlain }
    
    init(id: Identifier) {
        self.id = id
    }
}