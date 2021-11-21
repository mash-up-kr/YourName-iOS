//
//  LogoutAPI.swift
//  MEETU
//
//  Created by seori on 2021/11/21.
//

import Foundation
import Moya

struct LogoutAPI: ServiceAPI {

    private let accessToken: AccessToken
    
    init(accessToken: AccessToken) {
        self.accessToken = accessToken
    }
    
    typealias Response = Entity.Empty
    var path: String { "/logout" }
    var method: Moya.Method { .post }
    var task: Task { .requestPlain }
    var headers: [String : String]? {
        return ["authorization": self.accessToken]
    }
}
