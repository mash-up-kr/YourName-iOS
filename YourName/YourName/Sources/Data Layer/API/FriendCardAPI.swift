//
//  FriendCardAPI.swift
//  MEETU
//
//  Created by seori on 2021/11/27.
//

import Foundation

struct FriendCardAPI: ServiceAPI {
    typealias Response = Entity.FriendCard
    private let uniqueCode: String
    
    init(uniqueCode: String) {
        self.uniqueCode = uniqueCode
    }
    
    var path: String { "/namecards/\(self.uniqueCode)" }
    var method: Method { .get }
    var task: NetworkingTask { .requestPlain }
}
