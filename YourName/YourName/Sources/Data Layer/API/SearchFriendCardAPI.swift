//
//  SearchFriendCardAPI.swift
//  MEETU
//
//  Created by seori on 2021/11/27.
//

import Foundation

struct SearchFriendCardAPI: ServiceAPI {
    typealias Response = Entity.SearchFriendCard
    private let uniqueCode: String
    
    init(uniqueCode: String) {
        self.uniqueCode = uniqueCode
    }
    
    var path: String { "/namecards/\(self.uniqueCode)" }
    var method: Method { .get }
    var task: NetworkingTask { .requestPlain }
}
