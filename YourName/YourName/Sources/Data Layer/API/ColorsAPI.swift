//
//  ColorsAPI.swift
//  MEETU
//
//  Created by Booung on 2021/12/01.
//

import Foundation

struct ColorsAPI: ServiceAPI {
    var method: Method { .get }
    var task: NetworkingTask { .requestPlain }
    var path: String { "/users/bgcolors" }
}
extension ColorsAPI {
    struct Response: Decodable {
        let list: [Entity.BackgroundColor]
    }
}
