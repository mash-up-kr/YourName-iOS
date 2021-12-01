//
//  Entity.Contact.swift
//  MEETU
//
//  Created by Booung on 2021/11/20.
//

import Foundation

extension Entity {
    
    struct Contact: Codable {
        let category: ContactType?
        let value: String?
        let iconURL: String?
        
        enum CodingKeys: String, CodingKey {
            case category, value
            case iconURL = "iconUrl"
        }
    }
    
    enum ContactCategory: String, Codable {
        case phone = "Phone."
        case email = "Email."
        case instagram = "Instagram."
        case facebook = "Facebook."
        case youtube = "Youtube."
    }
    
}
