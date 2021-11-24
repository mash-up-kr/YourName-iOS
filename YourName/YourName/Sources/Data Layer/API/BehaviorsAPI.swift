//
//  BehaviorsAPI.swift
//  MEETU
//
//  Created by Booung on 2021/11/24.
//

import Foundation

struct BehaviorsAPI: ServiceAPI {
    var path: String { "/tmis/behaviors" }
    var method: Method { .get }
    var task: NetworkingTask { .requestPlain }
}

extension BehaviorsAPI {
    struct Response: Decodable {
        let list: [Entity.TMI]
    }
}
