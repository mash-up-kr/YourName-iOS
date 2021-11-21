//
//  Entity.UserOnboarding.swift
//  MEETU
//
//  Created by seori on 2021/11/21.
//

import Foundation

extension Entity {
    struct UserOnboarding: Decodable {
        let id: Int?
        let userId: Int?
        let makeFirstNameCard: Bool?
        let shareNameCard: Bool?
        let addNameCollectionNameCard: Bool?
        let makeCollection: Bool?
        let makeNameCards: Bool?
        let user: User?
        
        struct User: Decodable {
            let id: Int?
            let nickName: String?
            let providerName: String?
        }
    }
}
