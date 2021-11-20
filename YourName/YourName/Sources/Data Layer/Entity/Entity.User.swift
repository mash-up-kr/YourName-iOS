//
//  Entity.User.swift
//  MEETU
//
//  Created by Booung on 2021/11/20.
//

import Foundation

extension Entity {
    
    struct UserSession: Decodable {
        let accessToken: String?
        let refreshToken: String?
        let user: User?
    }
    
    struct User: Decodable {
        let id: String?
        let name: String?
        let role: String?
        let skills: [Skill]
        let contacts: [Contact]
        let personality: String?
        let bgColor: BackgroundColor?
        let tmis: [TMI]?
        let introduce: String?
    }
    
}
