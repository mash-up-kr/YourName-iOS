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
        let id: String?
        let title: String?
        let status: Status?
        let rewardImageURL: String?
        
        enum CodingKeys: String, CodingKey {
            case id
            case title
            case status
            case rewardImageURL = "imageUrl"
        }
    }
}

extension Entity.Quest {
    enum Status: String, Decodable, Equatable {
        case wait = "WAIT"
        case archieve = "DONE_WAIT"
        case done = "DONE"
    }
}
