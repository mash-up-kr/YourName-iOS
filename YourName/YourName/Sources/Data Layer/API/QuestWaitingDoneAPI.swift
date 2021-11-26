//
//  QuestWaitingDoneAPI.swift
//  MEETU
//
//  Created by Booung on 2021/11/27.
//

import Foundation

struct QuestWaitingDoneAPI: ServiceAPI {
    typealias Response = Entity.Empty
    
    var path: String { "/users/onboarding/\(questCode)/done-wait" }
    var method: Method { .put }
    var task: NetworkingTask { .requestPlain }
    
    init(questCode: String) {
        self.questCode = questCode
    }
    
    private let questCode: String
}
