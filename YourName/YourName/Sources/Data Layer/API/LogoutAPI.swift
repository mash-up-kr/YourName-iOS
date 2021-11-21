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
    
    init(accesToken: AccessToken) {
        self.accessToken = accesToken
    }
    
    typealias Response = Entity.Login
    var path: String { "/logout" }
    var method: Moya.Method { .post }
    var task: Task { .requestPlain }
    var headers: [String : String]? {
        return ["authorization": self.accessToken]
    }
}
