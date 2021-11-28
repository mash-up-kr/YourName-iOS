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
    
    private let uniqueCode: String
    private let collectionId: Int
    
    var path: String { "/collections/namecards/\(uniqueCode)"}
    var method: Method { .post }
    var task: NetworkingTask {
        return .requestParameters(parameters: ["collectionIds" : [self.collectionId]], encoding: JSONEncoding.default)
    }
    
    init(uniqueCode: String,
         collectionId: Int = 1) {
        self.uniqueCode = uniqueCode
        // 초기배포시에는 전체명함에만 추가할 수 있어 default값으로 1을 주었습니다,
        self.collectionId = collectionId
    }
}
