//
//  QuestDoneAPI.swift
//  MEETU
//
//  Created by Booung on 2021/11/26.
//

import Foundation

struct QuestDoneAPI: ServiceAPI {
    typealias Response = Entity.Empty
    
    var path: String { "/users/onboarding/\(questCode)/done" }
    var method: Method { .put }
    var task: NetworkingTask { .requestPlain }
    
    private let questCode: String
}
struct QuestWaitingDoneAPI: ServiceAPI {
    typealias Response = Entity.Empty
    
    var path: String { "/users/onboarding/\(questCode)/done" }
    var method: Method { .put }
    var task: NetworkingTask { .requestPlain }
    
    private let questCode: String
}

