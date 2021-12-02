//
//  Entity.TMI.swift
//  MEETU
//
//  Created by Booung on 2021/11/20.
//

import Foundation

extension Entity {
    
    struct TMI: Codable {
        let id: Identifier?
        let type: String?
        let name: String?
        let iconURL: String?
        
        enum CodingKeys: String, CodingKey {
            case id
            case type
            case name
            case iconURL = "iconUrl"
        }
    }
    
}
