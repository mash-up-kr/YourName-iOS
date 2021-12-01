//
//  LogoutAPI.swift
//  MEETU
//
//  Created by seori on 2021/11/21.
//

import Foundation
import Moya

struct LogoutAPI: ServiceAPI {
    
    typealias Response = Entity.Empty
    var path: String { "/logout" }
    var method: Moya.Method { .post }
    var task: Task { .requestPlain }
}

