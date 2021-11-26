//
//  Entity.Contact.swift
//  MEETU
//
//  Created by Booung on 2021/11/20.
//

import Foundation

extension Entity {
    
    struct Contact: Decodable {
        let category: ContactCategory?
        let value: String?
        let iconURL: String?
        
        enum CodingKeys: String, CodingKey {
            case category, value
            case iconURL = "iconUrl"
        }
    }
    
    enum ContactCategory: String, Decodable {
        case phone = "Phone."
        case email = "Email."
        case instagram = "Instagram."
        case facebook = "Facebook."
        case youtube = "Youtube."
    }
    
}
