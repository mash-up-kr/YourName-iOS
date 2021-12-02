//
//  NameCardAPI.swift
//  MEETU
//
//  Created by Booung on 2021/12/02.
//

import Foundation

struct AllFriendCardAPI: ServiceAPI {
    var path: String { "/collections/namecards" }
    var method: Method { .get }
    var task: NetworkingTask { .requestPlain }
}
extension AllFriendCardAPI {
    struct Response: Decodable {
        let list: [Entity.NameCard]?
    }
}
