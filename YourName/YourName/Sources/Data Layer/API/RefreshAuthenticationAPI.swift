//
//  RefreshAuthenticationAPI.swift
//  MEETU
//
//  Created by Booung on 2021/11/29.
//

import Foundation
import Moya

struct RefreshAuthenticationAPI: ServiceAPI {
    typealias Response = Entity.Authentication
    
    init(refreshToken: String) {
        self.refreshToken = refreshToken
    }
    
    var path: String { "/token-refresh" }
    var method: Method { .post }
    var headers: [String : String]? { [:] }
    var task: NetworkingTask {
        .requestParameters(
            parameters: ["refreshToken": refreshToken],
            encoding: JSONEncoding.default
        )
    }
    
    private let refreshToken: String
}
