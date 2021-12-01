//
//  Entity.MyNameCard.swift
//  MEETU
//
//  Created by seori on 2021/11/25.
//

import Foundation

extension Entity {
    struct MyNameCard: Decodable {
        let list: [NameCard]?
        
    }
    
    struct NameCard: Codable {
        let id: Int?
        let name: String?
        let role: String?
        let personality: String?
        let introduce: String?
        let uniqueCode: String?
        let image: Image?
        let user: User?
        let bgColor: BackgroundColor?
        let contacts: [Contact]?
        let personalSkills: [Skill]?
        let tmis: [TMI]?
    }

    struct NameCardCreation: Codable {
        let imgUrl: String?
        let bgColorId: Int?
        let name: String?
        let role: String?
        let skills: [Skill]?
        let contacts: [Contact]?
        let personality: String?
        let introduce: String?
        let tmiIds: [Int]?
    }
}
