//
//  RemoveMyNameCardAPI.swift
//  MEETU
//
//  Created by seori on 2021/11/30.
//

import Foundation

struct RemoveMyNameCardAPI: ServiceAPI {
    typealias Response = Entity.Empty
    private let uniqueCode: UniqueCode
    var path: String { "/namecards/\(uniqueCode)" }
    var method: Method { .delete }
    var task: NetworkingTask { .requestPlain }
    
    init(uniqueCode: UniqueCode) {
        self.uniqueCode = uniqueCode
    }
}
