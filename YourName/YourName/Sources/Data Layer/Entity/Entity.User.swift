//
//  Entity.User.swift
//  MEETU
//
//  Created by 송서영 on 2021/11/20.
//

import Foundation

extension Entity {
    
    struct User: Codable {
        let id: Identifier?
        let nickName: String?
        let role: String?
        let skills: [Skill]?
        let contacts: [Contact]?
        let personality: String?
        let bgColor: BackgroundColor?
        let tmis: [TMI]?
        let introduce: String?
        let providerName: Provider?
    }
    
    
    enum Provider: String, Codable {
        case kakao = "Kakao"
        case apple = "Apple"
    }
}
