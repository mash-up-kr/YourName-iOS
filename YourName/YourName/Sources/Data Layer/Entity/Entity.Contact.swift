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
    }
    
    enum ContactCategory: Decodable {
        case phone
        case email
        case instagram
        case facebook
        case youtube
    }
    
}
