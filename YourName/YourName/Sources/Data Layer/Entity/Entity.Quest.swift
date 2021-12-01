//
//  Entity.Quest.swift
//  MEETU
//
//  Created by Booung on 2021/11/25.
//

import Foundation
import KakaoSDKAuth

extension Entity {
    struct Quest: Decodable, Equatable {
        let meta: QuestMeta?
        let status: Status?
        let rewardImageURL: String?
        
        enum CodingKeys: String, CodingKey {
            case meta = "key"
            case status
            case rewardImageURL = "imageUrl"
        }
    }
}

extension Entity.Quest {
    enum Status: String, Decodable, Equatable {
        case notAchieved = "WAIT"
        case waitingDone = "DONE_WAIT"
        case done = "DONE"
    }
}
