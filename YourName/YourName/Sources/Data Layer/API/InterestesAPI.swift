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
    
    typealias Response = [Entity.TMI]
}
