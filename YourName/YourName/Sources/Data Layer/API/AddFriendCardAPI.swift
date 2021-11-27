//
//  AddFriendCardAPI.swift
//  MEETU
//
//  Created by seori on 2021/11/27.
//

import Foundation

struct AddFriendCardAPI: ServiceAPI {
    typealias Response = Entity.AddFriendCard
    private let uniqueCode: String
    
    init(uniqueCode: String) {
        self.uniqueCode = uniqueCode
    }
    
    var path: String { "/namecards/\(self.uniqueCode)" }
    var method: Method { .get }
    var task: NetworkingTask { .requestPlain }
}
