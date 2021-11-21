//
//  KaKaoLoginAPI.swift
//  MEETU
//
//  Created by seori on 2021/11/21.
//

import Foundation
import Moya

struct LoginAPI: ServiceAPI {


    let accessToken: AccessToken
    let provider: Provider
    
    init(accesToken: AccessToken,
         provider: Provider) {
        
        self.accessToken = accesToken
        self.provider = provider
        print(accessToken, "서영")
        print(provider, "서영")
    }
    
    typealias Response = Entity.Login
    var path: String {
        switch provider {
        case .kakao:
            return "/kakao-login"
        case .apple:
            return "/apple-login"
        }
    }
    var method: Moya.Method { .post }
    var task: Task { .requestParameters(parameters: [:], encoding: JSONEncoding.default) }
    var headers: [String : String]? {
        return ["authorization": self.accessToken]
    }
}
