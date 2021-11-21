//
//  Entity.Login.swift
//  MEETU
//
//  Created by seori on 2021/11/21.
//

import Foundation

extension Entity {
    
    struct Login: Decodable {
        
        let accessToken: String?
        let refreshToken: String?
        let userOnboarding: UserOnboarding?
        
        // MARK: UserOnboarding Entity
        struct UserOnboarding: Decodable {
            let id: Int?
            let userId: Int?
            let makeFirstNameCard: Bool?
            let shareNameCard: Bool?
            let addNameCollectionNameCard: Bool?
            let makeCollection: Bool?
            let makeNameCards: Bool?
            let user: User?
            
            // MARK: User Entity
            struct User: Decodable {
                let id: Int?
                let nickName: String?
                let providerName: String?
            }
        }
    }
}
