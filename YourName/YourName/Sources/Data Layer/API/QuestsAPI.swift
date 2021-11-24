//
//  QuestAPI.swift
//  MEETU
//
//  Created by Booung on 2021/11/25.
//

import Foundation


struct QuestsAPI: ServiceAPI {
    var path: String { "/users/onboarding" }
    var method: Method { .get }
    var task: NetworkingTask { .requestPlain }
    
}
extension QuestsAPI {
    struct Response: Decodable {
        let list: [Entity.Quest]?
    }
}
