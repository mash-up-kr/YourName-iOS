//
//  Entity.Skill.swift
//  MEETU
//
//  Created by Booung on 2021/11/20.
//

import Foundation


extension Entity {
    
    struct Skill: Decodable {
        let name: String
        let level: Int?
    }
    
}
