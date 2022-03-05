//
//  AddFriendCardAPI.swift
//  MEETU
//
//  Created by seori on 2021/11/28.
//

import Foundation
import Moya

struct AddFriendCardAPI: ServiceAPI {
    typealias Response = Entity.Empty
    
    private let uniqueCode: UniqueCode
    private let collectionIds: [Int]
    
    var path: String { "/collections/namecards/\(uniqueCode)"}
    var method: Method { .post }
    var task: NetworkingTask {
        return .requestParameters(parameters: ["collectionIds" : self.collectionIds],
                                  encoding: JSONEncoding.default)
    }
    
    init(uniqueCode: UniqueCode,
         collectionIds: [String]) {
        self.uniqueCode = uniqueCode
        self.collectionIds = collectionIds.compactMap { Int($0) }
    }
}
