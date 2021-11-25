//
//  Entity.User.swift
//  MEETU
//
//  Created by 송서영 on 2021/11/20.
//

import Foundation

extension Entity {
    
    struct User: Decodable {
        let id: String?
        let nickName: String?
        let providerName: Provider
        
        enum Provider: String, Decodable {
            case kakao
            case apple
        }
    }
}
