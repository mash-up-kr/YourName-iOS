//
//  AddCardBookAPI.swift
//  MEETU
//
//  Created by Seori on 2022/02/10.
//

import Foundation
import Moya

struct AddCardBookAPI: ServiceAPI {
    typealias Response = Entity.Empty
    private let name: String
    private let desc: String
    private let bgColorId: Int
    
    init(name: String, desc: String, bgColorId: Int) {
        self.name = name
        self.desc = desc
        self.bgColorId = bgColorId
    }
    
    var path: String { "/collections" }
    var method: Method { .post }
    var task: NetworkingTask {
        return .requestParameters(
            parameters: [
                "name": name,
                "description": desc,
                "bgColorId": bgColorId,
            ],
            encoding: JSONEncoding.default)
    }
}
