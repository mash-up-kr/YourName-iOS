//
//  ResignAPI.swift
//  MEETU
//
//  Created by seori on 2021/11/30.
//

import Foundation

struct ResignAPI: ServiceAPI {
    
    typealias Response = Entity.Empty
    
    var path: String { "/users" }
    var method: Method { .delete }
    var task: NetworkingTask { .requestPlain }

}
