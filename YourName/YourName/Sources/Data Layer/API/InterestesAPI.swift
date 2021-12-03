//
//  BehaviorsAPI.swift
//  MEETU
//
//  Created by Booung on 2021/11/24.
//

import Foundation

struct InterestesAPI: ServiceAPI {
    var path: String { "/tmis/behavior" }
    var method: Method { .get }
    var task: NetworkingTask { .requestPlain }
    var headers: [String : String]? = nil
    
    struct Response: Decodable {
        let list: [Entity.TMI]?
    }
}
