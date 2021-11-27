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
    
    struct NameCard: Decodable {
        let id: Int?
        let name: String?
        let role: String?
        let personality: String?
        let introduce: String?
        let uniqueCode: String?
        let image: String?
        let user: User?
        let bgColor: BackgroundColor?
        let contacts: [Contact]?
        let personalSkills: [Skill]?
    }

}
